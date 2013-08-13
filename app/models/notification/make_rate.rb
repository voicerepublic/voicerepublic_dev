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
class Notification::MakeRate < Notification::Base
  # attr_accessible :title, :body
  attr_accessible :other_id, :user_id, :klu_id
 
  belongs_to :user
  belongs_to :other, :class_name => 'User'
  # belongs_to :klu
   
  validates :other_id, :user_id, :klu_id, :presence => true
  
  after_create :generate_push_notification, :generate_mail_notification
  
  def to_s 
    I18n.t('model_notification_make_rate.please_rate', :name => other.name, :title => klu.title )
  end
end
