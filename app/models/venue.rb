# Attributes:
# * id [integer, primary, not null] - primary key
# * created_at [datetime, not null] - creation time
# * description [text] - TODO: document me
# * duration [integer] - TODO: document me
# * featured_from [datetime] - TODO: document me
# * host_kluuu_id [integer] - belongs to :host_kluuu
# * intro_video [string] - TODO: document me
# * start_time [datetime] - TODO: document me
# * summary [text] - TODO: document me
# * title [string]
# * updated_at [datetime, not null] - last update time
class Venue < ActiveRecord::Base
  attr_accessible :title, :summary, :description, :host_kluuu_id, :intro_video, :start_time, :duration, :featured_from
  attr_accessor :s_date, :s_time
  attr_accessible :s_date, :s_time
  
  belongs_to :host_kluuu, :class_name => 'Kluuu'
  has_many :venue_klus, :dependent => :destroy
  has_many :klus, :class_name => 'Klu', :through => :venue_klus
  has_many :comments, :as => :commentable, :dependent => :destroy, :order => "created_at DESC"
  has_many :articles, :dependent => :destroy, :order => "created_at DESC"
  has_many :notifications_new_venues, :class_name => 'Notification::NewVenue', :foreign_key => :other_id, 
            :dependent => :destroy
  has_many :notifications_venue_infos, :class_name => 'Notification::VenueInfo', :foreign_key => :other_id, 
            :dependent => :destroy
  has_many :notifications_new_venue_participants, :class_name => 'Notification::NewVenueParticipant', 
            :foreign_key => :other_id, :dependent => :destroy  
  validates :host_kluuu, :title, :summary, :description, :start_time, :duration, :presence => true
  
  
  before_validation :parse_datetimepicker
  after_create :generate_notification

  END_TIME_PGSQL = "start_time + duration * interval '1 minute'"

  scope :featured, proc { where('featured_from <= ?', Time.now.in_time_zone) }
  scope :not_past, proc { where("#{END_TIME_PGSQL} > ?", Time.now.in_time_zone) }  
  scope :upcoming_first, proc { order('start_time ASC') }

  MIN_TIME = 240
  DURATION = [ 30, 60, 90, 120, -1 ]
  #REPEATING = { I18n.t('model_venue.no_repeat') => 0, I18n.t('model_venue.weekly') => 1, 
  #              I18n.t('model_venue.biweekly') => 2, I18n.t('model_venue.monthly') => 3 }
  
  # returns 0 if past or already started
  def start_in_seconds
    [ (start_time - Time.now.in_time_zone).round, 0 ].max
  end

  def timed_out?
    min = ( duration < 0 ) ? 240 : duration
    ( start_time.in_time_zone + min.minutes ) <= Time.now.in_time_zone 
  end
  
  def ongoing?
    ! timed_out?  && ( start_time.in_time_zone + runtime.minutes ) >= Time.now.in_time_zone &&  start_time.in_time_zone < Time.now.in_time_zone
  end
  alias_method :live?, :ongoing?
  
  def past?
    (start_time.in_time_zone + runtime.minutes) < Time.now.in_time_zone
  end
  
  def self.of_user(user)
    Venue.joins(:host_kluuu => :user).where("user_id = ?", user.id)
  end
  
  
  def user_participates?(user)
    self.klus.collect { |k| k.user }.include?(user)
  end
  
  def attendies
    self.klus.collect { |k| k.user }.push(self.host_kluuu.user)
  end
  
  def guests
    self.klus.collect { |k| k.user }
  end
  
  def chat_name
    "vgc-#{self.id}"
  end
  
  def channel_name
    "/chatchannel/vgc-#{self.id}"
  end
  
  def channel_host_info
    "/chatchannel/host-info/vgc-#{self.id}"
  end
  
  def self.upcoming
    Venue.where("start_time > ?", Time.now - 1.hour).order("start_time ASC").limit(1).first
  end
  
  def self.one_day_ahead
    venues = Venue.where("start_time < ? AND start_time > ?", Time.now + 24.hours, Time.now + 23.hours)
  end
  
  def self.two_hour_ahead
    venues = Venue.where("start_time < ? AND start_time > ?", Time.now + 120.minutes, Time.now + 60.minutes )
  end
  
  def self.notify_next_day
    self.generate_time_info_for(self.one_day_ahead)
  end
  
  def self.notify_next_2_hour
    self.generate_time_info_for(self.two_hour_ahead)
  end
  
  def self.generate_time_info_for(venues)
    notifies = false
    venues.each do |venue|
      venue.attendies.each do |user|
        I18n.locale = user.account.preferred_locale
        Notification::VenueInfo.create(:user => user, :other => venue)
        notifies = true
      end
    end
    notifies
  end

  # called in controller on update of only
  # start_time attributes
  #
  def self.generate_renew_info_for(venue)
    venue.attendies.each do |user|
      I18n.locale = user.account.preferred_locale
      Notification::VenueInfo.create(:user => user, :other => venue)
    end
  end
  
  private
  
  def parse_datetimepicker
    self.logger.debug("Venue#parse_datetimepicker - timezone: #{Time.zone}")
    self.start_time =  Time.zone.parse("#{s_date}") if s_date
  end
  
  # returns runtime in minutes
  def runtime
    ( duration < 0 ) ? MIN_TIME : duration
  end
  
  
  
  def generate_notification
    host_kluuu.user.follower.each do |follower|
      if follower.account.prefs.inform_of_friends == "1" || true
        Notification::NewVenue.create(:user => follower, :other => self)
      end
    end
  end
  
end
