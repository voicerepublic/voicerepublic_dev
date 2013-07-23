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
class Notification::NewMessage < Notification::Base 
  attr_accessible :other_id, :user_id, :content, :url
 
  belongs_to :user
  belongs_to :other, :class_name => 'User'
   
  validates :other_id, :user_id, :url, :presence => true
  
  after_create :push_in_actionbar, :generate_mail_notification
  
  def to_s
    name = ''
    if other
      name = other.name
    else
      name = 'n.n.'
    end
    I18n.t('model_notification_new_message.new_message_from', :name => name , :default => 'you have a new message')
  end
  
  private
  
  def push_in_actionbar
    count = user.received_messages.receiver_unread.count
    js = "$('#messages-count-#{user_id}').removeClass('badge-info').addClass('badge-important').html(#{count});"
    ret = PrivatePub.publish_to("/notifications/#{user_id}", js)
  end
  
end
