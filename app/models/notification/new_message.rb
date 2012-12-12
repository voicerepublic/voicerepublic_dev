class Notification::NewMessage < Notification::Base 
  attr_accessible :other_id, :user_id, :content, :url
 
  belongs_to :user
  belongs_to :other, :class_name => 'User'
   
  validates :other_id, :user_id, :url, :presence => true
  
  after_create :push_in_actionbar, :generate_mail_notification
  
  def to_s
    I18n.t('model_notification_new_message.new_message_from', :name => other.name, :default => 'you have a new message')
  end
  
  private
  
  def push_in_actionbar
    count = user.received_messages.receiver_unread.count
    js = "$('#messages-count-#{user_id}').removeClass('badge-info').addClass('badge-important').html(#{count});"
    ret = PrivatePub.publish_to("/notifications/#{user_id}", js)
  end
  
end