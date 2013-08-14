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
# * user_id [integer] - belongs to :user
class Venue < ActiveRecord::Base

  LIVE_TOLERANCE = 5.minutes

  acts_as_taggable

  attr_accessible :title, :summary, :description, :intro_video, :featured_from,
                  :events_attributes, :tag_list
  
  belongs_to :user

  has_many :comments, :as => :commentable, :dependent => :destroy, :order => "created_at DESC"
  has_many :articles, :dependent => :destroy, :order => "created_at DESC"
  has_many :events, :dependent => :destroy, :inverse_of => :venue

  has_many :participations, :dependent => :destroy
  has_many :users, :through => :participations

  has_many :notifications_new_venues, :class_name => 'Notification::NewVenue',
           :foreign_key => :other_id,:dependent => :destroy
  has_many :notifications_venue_infos, :class_name => 'Notification::VenueInfo',
           :foreign_key => :other_id, :dependent => :destroy
  has_many :notifications_new_venue_participants, :class_name => 'Notification::NewVenueParticipant', 
           :foreign_key => :other_id, :dependent => :destroy  

  validates :title, :summary, :description, :tag_list, :presence => true
  
  after_create :generate_notification
  before_save :clean_taglist # prevent vollpfosten from adding hash-tag to tag-names

  accepts_nested_attributes_for :events

  scope :of_user, proc { |user| where(:user_id => user.id) }
  scope :featured, proc { where('featured_from <= ?', Time.now.in_time_zone) }
  scope :not_past, proc { joins(:events).merge(Event.not_past) }

  # start_time, duration, start_in_seconds wil return nil if no next_event
  delegate :start_time, :duration, :start_in_seconds, to: :next_event, allow_nil: true

  attr_accessible :image
  attr_accessor :image_file_name
  has_attached_file( :image,
                     :styles => { :medium => '242x145>', :thumb => "100x100>" },
                     :default_url => "/images/:style/missing.png" )

  # returns nil if no current or upcoming event
  def next_event
    events.not_past.upcoming_first.first
  end

  def end_time
    start_time.in_time_zone + duration.minutes
  end

  def reload_time
    return false if next_event.nil?
    (start_time.in_time_zone - Time.now.in_time_zone) - LIVE_TOLERANCE + rand * 3.0
  end

  def live?(opts={})
    return false if next_event.nil?
    tolerance = opts[:tolerance] || LIVE_TOLERANCE
    (end_time >= Time.now.in_time_zone - tolerance) and
      (start_time <= Time.now.in_time_zone + tolerance)
  end
  
  def past?
    return true if next_event.nil?
    end_time < Time.now.in_time_zone
  end
  alias_method :timed_out?, :past?
  
  def user_participates?(user)
    users.include?(user)
  end
  
  def attendies
    #self.klus.collect { |k| k.user }.push(self.host_kluuu.user)
    [ user ]
  end
  
  def guests
    #self.klus.collect { |k| k.user }
    []
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
  
  def clean_taglist
    self_tag_list = tag_list.map { |t| t.tr_s(' ', '_').gsub('#', '') }
  end
  
  def generate_notification
    user.follower.each do |follower|
      if follower.account.prefs.inform_of_friends == "1" || true
        Notification::NewVenue.create(:user => follower, :other => self)
      end
    end
  end
  
end
