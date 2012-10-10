class Notification::IncomingCall < Notification::Base 
  
  belongs_to :user, :class_name => 'Participant::Base'
  belongs_to :other, :class_name => 'Participant::Base'  # other here is klu-owner
  belongs_to :video_session
  
  attr_accessible :user_id, :other_id, :video_session_id
  
  #other_id can be a session id of the cookie in case an anonymous user calls
  validates_presence_of :user_id, :video_session_id, :other_id
  
  after_create :generate_push_notification
  
  def to_s
    I18n.t('.incoming_call', :caller => other ? other.user.name : 'anonymous')
  end
  
  private
  
  def generate_push_notification
    begin
      PrivatePub.publish_to("/notifications/#{user.user_id}", "alert(<%= self.to_s %>);")
    rescue Exception => e
      self.logger.error("#{self.class.name}#generate_push_notification - error: #{e.inspect}")
    end  
  end
  
end