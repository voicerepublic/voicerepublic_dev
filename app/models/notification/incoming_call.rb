class Notification::IncomingCall < Notification::Base 
  
  belongs_to :user
  belongs_to :video_session
  
  attr_accessible :user_id, :other_id, :video_session_id
  
  #other_id can be a session id of the cookie in case an anonymous user calls
  validates_presence_of :user_id, :video_session_id, :other_id
  
  after_create :generate_push_notification
  
  private
  
  
  def generate_push_notification
    begin
      PrivatePub.publish_to("/notifications/#{user.id}", "alert('someone is calling you now!');")
    rescue Exception => e
      self.logger.error("Notification::IncomingCall#generate_push_notification - error: #{e.inspect}")
    end  
  end
  
  
end