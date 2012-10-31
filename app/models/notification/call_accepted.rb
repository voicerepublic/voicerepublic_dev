class Notification::CallAccepted < Notification::Base 
 
  attr_accessible :user_id, :other_id, :video_session_id, :url, :other, :user
  
  after_create :generate_push_notification
  
  belongs_to :video_session
  belongs_to :other, :class_name => 'User'  # other here is klu-owner
  belongs_to :user

  #user_id can be a session id of the cookie in case an anonymous user calls
  validates_presence_of :url, :video_session_id, :other_id, :user_id
  
  
  
  private
  
  def generate_push_notification
    begin
      PrivatePub.publish_to("/notifications/#{user_id}", "alert('call accepted!');")
    rescue Exception => e
      self.logger.error("Notification::CallAccepted#generate_push_notification - error: #{e.inspect}")
    end  
  end
  
end