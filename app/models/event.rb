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

end
