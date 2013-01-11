class Venue < ActiveRecord::Base
  attr_accessible :title, :description, :host_kluuu_id, :intro_video, :start_time
  
  belongs_to :host_kluuu, :class_name => 'Kluuu'
  
  has_many :venue_klus, :dependent => :destroy
  has_many :klus, :class_name => 'Klu', :through => :venue_klus
  
  validates :host_kluuu, :title, :description, :start_time, :presence => true
  
  
  after_create :generate_notification
  
  private
  
  def generate_notification
    
  end
end
