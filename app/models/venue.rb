class Venue < ActiveRecord::Base
  attr_accessible :title, :description, :host_kluuu_id, :intro_video, :start_time
  
  belongs_to :host_kluuu, :class_name => 'Kluuu'
  has_many :venue_klus, :dependent => :destroy
  has_many :klus, :class_name => 'Klu', :through => :venue_klus
  
  validates :host_kluuu, :title, :description, :start_time, :presence => true
  
  
  after_create :generate_notification
  
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
