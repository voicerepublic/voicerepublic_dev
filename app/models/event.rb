# Attributes:
# * id [integer, primary, not null] - primary key
# * created_at [datetime, not null] - creation time
# * duration [integer] - TODO: document me
# * start_time [datetime] - TODO: document me
# * updated_at [datetime, not null] - last update time
# * venue_id [integer] - belongs to :venue
class Event < ActiveRecord::Base

  DURATIONS = [ 30, 60, 90, 120, 240 ]

  attr_accessor :s_date, :s_time
  attr_accessible :s_date, :s_time
  attr_accessible :duration, :start_time

  belongs_to :venue, :inverse_of => :events

  END_TIME_PGSQL = "events.start_time + events.duration * interval '1 minute'"

  scope :not_past, proc { where("#{END_TIME_PGSQL} > ?", Time.now.in_time_zone) }
  scope :upcoming_first, proc { order('start_time ASC') }

  validates :venue, :start_time, :duration, :presence => true

  before_validation :parse_datetimepicker

  # returns 0 if past or already started
  def start_in_seconds
    [ (start_time - Time.now.in_time_zone).round, 0 ].max
  end

  private

  def parse_datetimepicker
    self.logger.debug("Venue#parse_datetimepicker - timezone: #{Time.zone}")
    self.start_time =  Time.zone.parse("#{s_date}") if s_date
  end

end
