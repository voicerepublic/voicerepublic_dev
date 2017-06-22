# Devices which are online are expected to send a heartbeat once in a
# while. If the last heartbeat is too old, the event `disappear!` will
# be called. `disappear!` will retain the state of device.
#
# If a disappeared device is coming back online, it makes sense to
# check for an interrupted upload or display a warning message.
#
class Device < ActiveRecord::Base

  self.inheritance_column = false

  belongs_to :organization
  has_one :venue
  has_many :device_reports
  has_many :events, as: :source

  validates :identifier, presence: true
  validates :pairing_code, uniqueness: true, allow_nil: true
  validates :name, uniqueness: { scope: :organization }, allow_blank: true

  serialize :options

  after_create :generate_pairing_code!

  after_save :propagate_changes

  ONLINE = %w( pairing running )

  scope :online, -> { where(disappeared_at: nil).where('state IN (?)', ONLINE) }
  scope :unclaimed, -> { where(organization_id: nil) }
  scope :with_ip, ->(ip) { where(public_ip_address: ip) }
  scope :disappeared, -> { where.not(disappeared_at: nil) }
  scope :survey, -> { group(:type).count }

  include ActiveModel::Transitions

  # TODO fix the state machine or abolish entirely
  state_machine auto_scopes: true do

    state :unpaired # offline & unpaired (initial state)
    state :pairing  # online & unpaired
    state :running  # online & paired
    state :starting
    state :offline

    event :register do # remote
      # unpaired devices
      transitions from: [:unpaired, :pairing], to: :pairing
      # paired devices
      transitions from: Device.available_states, to: :running
    end

    event :complete_pairing, timestamp: :paired_at do # local
      # pairing while offline
      transitions from: :unpaired, to: :offline,
                  on_transition: :release_pairing_code
      # pairing while online
      transitions from: :pairing, to: :running,
                  on_transition: :release_pairing_code
    end

    event :shutdown do # remote
      transitions from: Device.available_states, to: :offline
    end

    event :restart do # remote
      transitions from: Device.available_states, to: :starting
    end

  end

  def manifestation
    case type
    when "Streambox" then :box
    when "vr-restream" then :app
    else :box
    end
  end

  def disappear!
    update_attribute :disappeared_at, Time.now
  end

  def appear!
    update_attribute :disappeared_at, nil
  end

  # this is returned on registering
  def provisioning_data
    {
      name: name,
      state: state,
      capture_device: capture_device,
      pairing_code: pairing_code,
      public_ip_address: public_ip_address,
      report_interval: report_interval,
      heartbeat_interval: heartbeat_interval,
      # FIXME add security
      storage: Settings.devices.storage.to_hash
    }
  end

  def to_param
    identifier
  end

  def channel
    [nil, :device, identifier] * '/'
  end

  def opts
    OpenStruct.new(options)
  end

  # details returned on polling by desktop app
  def details
    Hash.new.tap do |details|
      details[:name] = name
      details[:state] = state
      details[:version] = 11
      if venue.present?
        details[:venue] = {
          name: venue.name,
          state: venue.state,
          icecast: venue.icecast_params
        }
      end
    end
  end

  def for_venues
    {
      id: id,
      name: name
    }
  end

  def release_pairing_code
    self.pairing_code = nil
  end

  # model callbacks

  def generate_pairing_code!
    self.pairing_code = ('0'..'9').to_a.shuffle[0,4].join
    self.save!
  rescue # catches violation of uniqueness constraint
    retry
  end

  def propagate_changes
    Faye.publish_to '/admin/devices', attributes
  end

  def old_recordings
    files.select { |f| f.key.match(/recording_\d+_\d+\.ogg$/) }.map do |file|
      {
        name: file.key.sub(prefix, ''),
        date: Time.at(file.key.match(/_(\d+)(_\d+)?\.ogg$/)[1].to_i),
        duration: hms(estimate_duration(file.content_length)),
        size: file.content_length,
        link: "/backup/#{file.key}"
      }
    end
  end

  def new_recordings
    files.select { |f| f.key.match(/rec_\d+_\d+\.ogg$/) }.map do |file|
      key = file.key.sub(prefix, '')
      {
        name: key,
        date: DateTime.strptime(key, 'rec_%Y%m%d_%H%M%S.ogg').to_time,
        duration: hms(estimate_duration(file.content_length)),
        size: file.content_length,
        link: "/backup/#{file.key}"
      }
    end
  end

  def recordings(period=14.days)
    (new_recordings + old_recordings).reject do |rec|
      rec[:date] < period.ago
    end
  end

  def start_jumphost
    self.jumphost_private_key,
    self.jumphost_public_key = SshKeypair.generate
    save!

    JumphostInstance.create(device: self).launch!
  end

  private

  def files
    Storage.get(bucket, prefix).files.sort_by(&:key).reverse
  end

  def bucket
    Settings.storage.backup_recordings
  end

  def prefix
    identifier+'/'
  end

  def hms(total_seconds)
    Time.at(total_seconds).utc.strftime("%H:%M:%S")
  end

  def estimate_duration(size)
    # based on the observation 1 MB per 87 seconds
    (size / 1024.0 ** 2) * 87
  end

end
