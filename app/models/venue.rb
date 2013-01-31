class Venue < ActiveRecord::Base
  attr_accessible :title, :description, :host_kluuu_id, :intro_video, :start_time, :duration, :repeating
  
  belongs_to :host_kluuu, :class_name => 'Kluuu'
  has_many :venue_klus, :dependent => :destroy
  has_many :klus, :class_name => 'Klu', :through => :venue_klus
  
  validates :host_kluuu, :title, :description, :start_time, :duration, :repeating, :presence => true
  
  
  after_create :generate_notification
  
  DURATION = [ 30, 60, 90, 120, -1 ]
  REPEATING = { I18n.t('model_venue.no_repeat') => 0, I18n.t('model_venue.weekly') => 1, I18n.t('model_venue.biweekly') => 2, I18n.t('model_venue.monthly') => 3 }
  
  def user_participates?(user)
    self.klus.collect { |k| k.user }.include?(user)
  end
  
  def attendies
    self.klus.collect { |k| k.user }.push(self.host_kluuu.user)
  end
  
  def Venue.upcoming
    Venue.where("start_time > ?", Time.now - 1.hour).order("start_time ASC").limit(1).first
  end
  
  def chat_name
    "vgc-#{self.id}"
  end
  
  def channel_name
    "/chatchannel/vgc-#{self.id}"
  end
  
  private
  
  def generate_notification
    
  end
end
