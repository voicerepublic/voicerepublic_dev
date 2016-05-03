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

  validates :identifier, presence: true

  serialize :options

  ONLINE = %w( pairing idle streaming )

  scope :online, -> { where(disappeared_at: nil).where('state IN (?)', ONLINE) }
  scope :unclaimed, -> { where(organization_id: nil) }
  scope :with_ip, ->(ip) { where(public_ip_address: ip) }
  scope :disappeared, -> { where.not(disappeared_at: nil) }

  include ActiveModel::Transitions

  state_machine auto_scopes: true do

    state :unpaired # offline & unpaired (initial state)
    state :pairing # online & still unpaired
    state :idle # online, paired & not streaming
    state :streaming, enter: :signal_start_stream
    state :offline

    event :register do # remote
      transitions from: [:unpaired, :pairing], to: :pairing
      transitions from: [:offline, :idle, :streaming], to: :idle
    end

    event :complete_pairing, timestamp: :paired_at do # local
      transitions from: :pairing, to: :idle
    end

    event :start_stream do # local
      transitions from: :idle, to: :streaming
    end

    event :stop_stream do # local
      transitions from: :streaming, to: :idle
    end

    event :deregister do # remote
      transitions from: [:idle, :streaming], to: :offline
    end

    event :reset do
      transitions from: [:streaming, :idle], to: :idle,
                  on_transition: :signal_stop_stream
    end
  end

  def disappear!
    update_attribute :disappeared_at, Time.now
  end

  def appear!
    update_attribute :disappeared_at, nil
  end

  def provisioning_data
    {
      name: name,
      state: state,
      target: target,
      public_ip_address: public_ip_address,
      report_interval: report_interval,
      heartbeat_interval: heartbeat_interval,

      faye_url: opts.faye_url || Settings.devices.faye.server,
      faye_secret: opts.faye_secret || Settings.devices.faye.secret_token
    }
  end

  def to_param
    identifier
  end

  def channel
    [nil, :device, identifier] * '/'
  end

  # state machine callbacks

  def signal_start_stream
    Faye.publish_to(channel, event: 'start_stream', icecast: venue.icecast_params)
    Rails.logger.info "Started Stream from device '#{name}' to '#{venue.stream_url}'"
  end

  def signal_stop_stream
    Faye.publish_to(channel, event: 'stop_stream', icecast: venue.icecast_params)
    Rails.logger.info "Stopped Stream from device '#{name}' to '#{venue.stream_url}'"
  end

  def opts
    OpenStruct.new(options)
  end

end
