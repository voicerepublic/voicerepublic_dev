# Devices which are online are expected to send a heartbeat once in a
# while. If the last heartbeat is too old, the event `disappear!` will
# be called.
#
# If a disappeared device is coming back online, it makes sense to
# check for an interrupted upload or display a warning message.
#
class Device < ActiveRecord::Base

  self.inheritance_column = false

  belongs_to :organization

  validates :identifier, presence: true

  ONLINE = %w( pairing idle streaming uploading )

  scope :online, -> { where('state IN (?)', ONLINE) }

  scope :unclaimed, -> { where(organization: nil) }

  include ActiveModel::Transitions

  state_machine auto_scopes: true do

    state :unpaired # offline & unpaired (initial state)
    state :pairing # online & still unpaired
    state :idle # online, paired & not streaming
    state :streaming
    state :uploading
    state :offline
    state :disappeared # assumed offline, did not deregister

    event :register do # remote
      transitions from: :unpaired, to: :pairing
      transitions from: :offline, to: :idle
      transitions from: :disappeared, to: :idle
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

    event :start_upload do
      transitions from: :idle, to: :uploading
    end

    event :deregister do # remote
      transitions from: [:idle, :streaming, :uploading], to: :offline
    end

    event :disappear, timestamp: :disappeared_at do # local
      transitions from: :pairing, to: :unpaired
      transitions from: [:idle, :streaming, :uploading], to: :disappeared
    end

  end

  def provisioning_data
    {
      name: name,
      state: state,
      target: target,
      public_ip_address: public_ip_address,
      report_interval: report_interval,
      heartbeat_interval: heartbeat_interval,

      faye_url: Settings.faye.server,
      faye_secret: Settings.faye.secret_token
    }
  end

end
