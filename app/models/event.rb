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

  validates :venue, :start_time, :duration, :presence => true

  before_validation :parse_datetimepicker

  private

  def parse_datetimepicker
    self.logger.debug("Venue#parse_datetimepicker - timezone: #{Time.zone}")
    self.start_time =  Time.zone.parse("#{s_date}") if s_date
  end

end
