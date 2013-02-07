class Notification::NewVenue < Notification::Base 
  # attr_accessible :title, :body 
  attr_accessible :other_id, :user_id, :content, :other, :user
  
  belongs_to :user
  belongs_to :other, :class_name => 'Venue'
   
  validates :other_id, :user_id, :presence => true
  
  after_create :generate_mail_notification
  
  def to_s
    I18n.t('model_notification_new_venue.friend_created_new_venue', :name => other.title)
  end
  
end
