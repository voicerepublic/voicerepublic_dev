class Notification::VenueInfo < Notification::Base 
  attr_accessible :other_id, :user_id, :content, :other, :user
  
  belongs_to :user
  belongs_to :other, :class_name => 'Venue'   
   
  validates :other_id, :user_id, :presence => true
  
  after_create :generate_mail_notification, :generate_push_notification
  
  def to_s
    I18n.t('model_notification_venue_info.venue_starts_soon', :title => other.title, :time => I18n.l(other.start_time) )
  end
  
end
