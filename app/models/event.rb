# Attributes:
# * id [integer, primary, not null] - primary key
# * created_at [datetime, not null] - creation time
# * duration [integer] - TODO: document me
# * end_at [datetime] - TODO: document me
# * record [boolean] - TODO: document me
# * recording [string] - TODO: document me
# * start_time [datetime] - TODO: document me
# * title [string, not null]
# * updated_at [datetime, not null] - last update time
# * venue_id [integer] - belongs to :venue
class Event < ActiveRecord::Base

  DURATIONS = [ 30, 45, 60, 90, 120, 240 ]

  attr_accessible :title, :start_time, :duration, :record

  attr_accessor :s_date, :s_time
  attr_accessible :s_date, :s_time

  belongs_to :venue, :inverse_of => :events

  scope :not_past,          proc { where(end_at: nil) }
  scope :upcoming_first,    proc { order('start_time ASC') }
  scope :past,              proc { where('events.end_at IS NOT NULL') }
  scope :most_recent_first, proc { order('events.end_at DESC') }

  validates :venue, :title, :start_time, :duration, :presence => true
  validate :must_not_exist_upcoming, on: :create

  before_validation :parse_datetimepicker
  after_create :notify_participants

  # returns 0 if past or already started
  def start_in_seconds
    [ (start_time - Time.now.in_time_zone).round, 0 ].max
  end

  private

  def parse_datetimepicker
    self.logger.debug("Venue#parse_datetimepicker - timezone: #{Time.zone}")
    self.start_time =  Time.zone.parse("#{s_date}") if s_date
  end

  def notify_participants
    venue.users.each do |participant|
      UserMailer.new_talk_notification(self, participant).deliver
    end
  end

  def must_not_exist_upcoming
    if venue && venue.events.not_past.any?
      errors.add(:venue, 'Must be only one upcoming event')
    end
  end

end
