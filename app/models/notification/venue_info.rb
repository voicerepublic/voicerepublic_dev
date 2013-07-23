# Attributes:
# * id [integer, primary, not null] - primary key
# * anon_id [string] - TODO: document me
# * content [text] - TODO: document me
# * created_at [datetime, not null] - creation time
# * klu_id [integer] - TODO: document me
# * other_id [integer] - belongs to :other
# * read [boolean] - TODO: document me
# * type [string] - TODO: document me
# * updated_at [datetime, not null] - last update time
# * url [string] - TODO: document me
# * user_id [integer] - belongs to :user
# * video_session_id [integer] - TODO: document me
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
