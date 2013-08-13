# Attributes:
# * id [integer, primary, not null] - primary key
# * anon_id [string] - TODO: document me
# * content [text] - TODO: document me
# * created_at [datetime, not null] - creation time
# * klu_id [integer] - belongs to :klu
# * other_id [integer] - belongs to :other
# * read [boolean] - TODO: document me
# * type [string] - TODO: document me
# * updated_at [datetime, not null] - last update time
# * url [string] - TODO: document me
# * user_id [integer] - belongs to :user
# * video_session_id [integer] - TODO: document me
class Notification::NewRating < Notification::Base 
  #attr_accessible :other_id, :user_id, :klu_id, :content
  attr_accessible :other_id, :user_id, :content
 
  belongs_to :user
  belongs_to :other, :class_name => 'User'
  #belongs_to :klu
   
  #validates :other_id, :user_id, :klu_id, :content , :presence => true
  validates :other_id, :user_id, :content , :presence => true
  
  after_create :generate_push_notification
  after_create :generate_mail_notification
  
  def to_s 
    I18n.t('model_notification_new_rating.you_got_rated_by', :name => other.name )
  end
  
end
