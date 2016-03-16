class Venue < ActiveRecord::Base

  PROVISIONING_WINDOW = 90.minutes
  PROVISIONING_TIME = 210.seconds

  extend FriendlyId
  friendly_id :slug_candidates, use: [:slugged, :finders]

  include ActiveModel::Transitions

  state_machine auto_scopes: true do

    state :offline, enter: :reset_ephemeral_details
    state :provisioning, enter: :provision, exit: :complete_details
    state :ready
    state :connected # aka. streaming
    state :disconnected # aka. lost connection

    event :start_provisioning, timestamp: :started_provisioning_at do
      transitions from: :offline, to: :provisioning
    end
    event :complete_provisioning, timestamp: :completed_provisioning_at do
      transitions from: :provisioning, to: :ready
    end
    event :connect do
      transitions from: [:ready, :disconnected], to: :connected
    end
    event :disconnect do
      transitions from: :connected, to: :disconnected
    end
    event :shutdown, guard: :shutdown? do
      transitions from: [:ready, :connected, :disconnected],
                  to: :offline, on_transition: :unprovision
    end
    # for emergencies only, may leave running instances behind!
    event :reset do
      transitions from: :provisioning, to: :offline
    end
  end

  before_create :set_default_instance_type

  def set_default_instance_type
    self.instance_type = Settings.icecast.ec2.default_instance_type
  end

  def generate_client_token
    [ slug, Time.now.to_i, generate_password(4) ] * '-'
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
    # TODO execute userdata on localhost
    # TODO adjust userdata's detection of public_ip for localhost
    # maybe with http://serverfault.com/questions/462903/how-to-know-if-a-machine-is-an-ec2-instance
  end

  def provision_test
    # TODO find a way
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
  end

  def shutdown?
    # TODO check if all data is save!
    # TODO check if there is no other talk within PROVISIONING_WINDOW on this venue
    true
  end

  # called on event shutdown
  def unprovision
    send("unprovision_#{Rails.env}")
  end

  def unprovision_production
    EC2.servers.get(instance_id).destroy
  end

  def unprovision_development
    system 'docker stop icecast'
  end

  def unprovision_test
    # anything to do here?
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

  def complete_details
    self.stream_url = build_stream_url
  end

  def userdata
    ERB.new(userdata_template).result(binding)
  end

  def userdata_template
    File.read(Rails.root.join('lib/templates/userdata.sh.erb'))
  end

  def darkice_config
    raise "Not available in state #{state}" if offline? or provisioning?
    ERB.new(darkice_config_template).result(binding)
  end

  def darkice_config_template
    File.read(Rails.root.join('lib/templates/darkice.cfg.erb'))
  end

  def env_list
    ERB.new(darkice_config_template).result(binding)
  end

  def env_list_template
    File.read(Rails.root.join('lib/templates/env.list.erb'))
  end

  def icecast_callback_url
    [ Settings.root_url, :icecast ] * '/'
  end

  def event_fired(*args)
    Emitter.venue_transition(self, args)
  end

  belongs_to :user
  has_many :talks

  validates :name, :user_id, presence: true

  serialize :options

  # provides easier access to options
  # and allows strings as keys in yaml
  def opts
    OpenStruct.new(options)
  end

  # current single page app state
  def atom
    {
      venue: attributes,
      talks: talks.map(&:attributes),
      now: Time.now.to_i
    }
  end

  private

  def slug_candidates
    [ :name, [:id, :name] ]
  end

end
