class Venue < ActiveRecord::Base

  PROVISIONING_WINDOW = 90.minutes
  # PROVISIONING_WINDOW = 12.hours
  PROVISIONING_DURATION = 4.minutes

  extend FriendlyId
  friendly_id :slug_candidates, use: [:slugged, :finders]

  belongs_to :user #:organization
  belongs_to :device
  has_many :talks

  validates :name, :user_id, presence: true
  validates :client_token, uniqueness: true, allow_blank: true

  serialize :options

  after_save :propagate_changes

  attr_accessor :event

  include ActiveModel::Transitions

  state_machine auto_scopes: true do

    state :offline, enter: :reset_ephemeral_details # aka. unavailable
    state :available
    state :provisioning, enter: :provision, exit: :complete_details
    state :device_required
    state :awaiting_stream, enter: :start_streaming
    state :connected # aka. streaming
    state :disconnected # aka. lost connection

    # issued by the venues controller
    event :become_available do
      transitions from: :offline, to: :available, guard: :in_provisioning_window?
    end
    event :start_provisioning, timestamp: :started_provisioning_at do
      transitions from: :available, to: :provisioning
    end
    event :select_device do
      transitions from: [:device_required, :awaiting_stream,
                         :connected, :disconnected],
                  to: :awaiting_stream
    end

    # issued by the icecast endpoint middleware
    event :complete_provisioning, timestamp: :completed_provisioning_at do
      transitions from: :provisioning, to: :awaiting_stream, guard: :device_present?
      transitions from: :provisioning, to: :device_required
    end
    event :connect do
      transitions from: [:awaiting_stream, :disconnected], to: :connected
    end
    event :disconnect do
      transitions from: :connected, to: :disconnected
    end

    # issued by ?
    event :shutdown do
      transitions from: [:device_required, :awaiting_stream,
                         :connected, :disconnected],
                  to: :offline, on_transition: :unprovision,
                  guard: :shutdown?
    end

    # for emergencies only, may leave running instances behind!
    event :reset do
      transitions from: [:available, :provisioning, :device_required,
                         :awaiting_stream, :connected, :disconnected],
                  to: :offline, on_transition: :unprovision
    end
  end

  before_create :set_default_instance_type

  def set_default_instance_type
    self.instance_type = Settings.icecast.ec2.default_instance_type
  end

  def generate_client_token
    [ slug[0, 64-16], Time.now.to_i, generate_password(4) ] * '-'
  end

  def generate_mount_point
    SecureRandom.uuid
  end

  def generate_password(length=8)
    ('a'..'z').to_a.shuffle[0,length].join
  end

  def provisioning_parameters
    [
      Settings.icecast.ec2.image,
      1, # min
      1, # max
      {
        "InstanceType"  => instance_type || set_default_instance_type,
        "SecurityGroup" => Settings.icecast.ec2.security_group,
        "KeyName"       => Settings.icecast.ec2.key_name,
        "ClientToken"   => client_token,
        "UserData"      => userdata
      }
    ]
  end

  def provisioning_file
    "/tmp/userdata_#{id}.sh"
  end

  def port
    Settings.icecast.url.port
  end

  def build_stream_url
    protocol = Settings.icecast.url.protocol
    url = [ protocol, public_ip_address ] * '://'

    regular = [['80', 'http'], ['443', 'https']]

    url = [ url, port ] * ':' unless  regular.include?([port.to_s, protocol])

    [ url, mount_point ] * '/'
  end

  def userdata
    ERB.new(userdata_template).result(binding)
  end

  # this is only required for darkice as a streaming device
  # the box has it's own template for darkice.
  def darkice_config
    raise "Not available in state #{state}" if offline? or provisioning?
    ERB.new(darkice_config_template).result(binding)
  end

  def butt_config
    raise "Not available in state #{state}" if offline? or provisioning?
    ERB.new(butt_config_template).result(binding)
  end

  # This is used in userdata.
  #
  def env_list
    ERB.new(env_list_template).result(binding)
  end

  def icecast_callback_url
    Settings.icecast.callback_url
  end

  def icecast_params
    {
      public_ip_address: public_ip_address,
      source_password: source_password,
      mount_point: mount_point,
      port: port
    }
  end

  # provides easier access to options
  # and allows strings as keys in yaml
  def opts
    OpenStruct.new(options)
  end

  def channel
    "/down/venue/#{id}"
  end

  # current single page app state
  def snapshot
    {
      venue: attributes.merge(
        provisioning_duration: PROVISIONING_DURATION,
        channel: channel,
        talks: talks_as_array,
        user: user.attributes.merge(
          image_url: user.avatar.thumb('36x36').url
        ),
        availability: availability
      ),
      devices: Device.all.map(&:attributes),
      now: Time.now.to_i
    }
  end

  # private
  def talks_as_array
    talks.map do |talk|
      attrs = talk.attributes
      attrs.delete('storage')
      attrs.delete('listeners')
      attrs.delete('session')
      attrs
    end
  end

  def propagate_changes
    return if Rails.env.test?
    push_snapshot
  end

  def push_snapshot
    message = { event: 'snapshot', snapshot: snapshot }
    Faye.publish_to channel, message
  end

  # Returns the time the provisioning window will open.
  #
  def availability
    return false if talks.prelive.empty?

    talks.prelive.ordered.first.starts_at.to_i - PROVISIONING_WINDOW
  end

  # This is used in userdata.
  #
  # This names the bucket which will be mounted on the ec2 instance
  # running the icecast server.
  #
  # This is only used on ec2 instances.
  #
  def recordings_bucket
    Settings.storage.recordings
  end

  # This is used in userdata.
  #
  # It is used as the `host-src` of the docker volume.
  #
  # For production this is '/data' (the mountpoint of the bucket).
  #
  # For development this should probably be `/tmp/recordings` or an
  # absolute path to a local folder, which is not tracked by git.
  #
  def recordings_path
    Settings.paths.recordings
  end

  # This is used in userdata to mount the s3 bucket with s3fs.
  #
  def aws_credentials
    [ Settings.fog.storage.aws_access_key_id,
      Settings.fog.storage.aws_secret_access_key ] * ':'
  end

  # --- state machine callbacks

  def in_provisioning_window?
    return false if talks.prelive.empty?

    availability <= Time.now.to_i
  end

  def reset_ephemeral_details
    self.client_token = nil
    self.instance_id = nil
    self.public_ip_address = nil
    self.stream_url = nil
    self.mount_point = nil
    self.source_password = nil
    self.admin_password = nil
    self.started_provisioning_at = nil
    self.completed_provisioning_at = nil
    # self.device = nil # do not reset!
  end

  def complete_details
    self.stream_url = build_stream_url

    if Rails.env.development? and File.exist?(provisioning_file)
      FileUtils.rm(provisioning_file)
    end
  end

  def start_streaming
    return unless device.present?

    device.start_stream!
  end

  def device_present?
    device.present? || device_name.present?
  end

  # called on event shutdown
  def unprovision
    send("unprovision_#{Rails.env}")

    device.reset! if device.present?
  end

  def unprovision_production
    EC2.servers.get(instance_id).destroy
  end

  def unprovision_development
    puts 'Stopping icecast docker container...'
    system 'docker stop icecast'
    puts 'Removing icecast docker container...'
    system 'docker rm icecast'
  end

  def unprovision_test
    # anything to do here?
  end

  def provision
    assign_attributes( source_password: generate_password,
                       admin_password: generate_password,
                       client_token: generate_client_token,
                       mount_point: generate_mount_point )
    send("provision_#{Rails.env}")
  end

  def provision_production
    response = EC2.run_instances(*provisioning_parameters)
    self.instance_id = response.body["instancesSet"].first["instanceId"]
  end

  def provision_development
    f = File.open(provisioning_file, 'w', 0700)
    f.write(userdata)
    f.close

    # for debugging
    # puts userdata
    FileUtils.cp f.path, 'userdata.sh'

    puts 'Running provisioning file...'
    spawn provisioning_file
  end

  def provision_test
    # TODO find a way
  end

  def shutdown?
    # TODO check if all data is save!
    # TODO check if there is no other talk within PROVISIONING_WINDOW on this venue
    true
  end

  private

  def event_fired(*args)
    Emitter.venue_transition(self, args)
  end

  def slug_candidates
    [ :name, [:id, :name] ]
  end

  def userdata_template
    File.read(Rails.root.join('lib/templates/userdata.sh.erb'))
  end

  def darkice_config_template
    File.read(Rails.root.join('lib/templates/darkice.cfg.erb'))
  end

  def butt_config_template
    File.read(Rails.root.join('lib/templates/butt.cfg.erb'))
  end

  def env_list_template
    File.read(Rails.root.join('lib/templates/env.list.erb'))
  end

end
