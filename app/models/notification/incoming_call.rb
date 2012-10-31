class Notification::IncomingCall < Notification::Base 
  attr_accessible :user_id, :other_id, :video_session_id, :other, :user
  
  belongs_to :user
  belongs_to :video_session
  belongs_to :other, :class_name => 'User'
  
  #other_id can be a session id of the cookie in case an anonymous user calls
  validates_presence_of :user_id, :video_session_id, :other_id
  
  after_create :generate_push_notification
  
  def to_s
    I18n.t('.incoming_call', :caller => other ? other.name : 'anonymous')
  end
  
end