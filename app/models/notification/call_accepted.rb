class Notification::CallAccepted < Notification::Base 
 
  belongs_to :user, :class_name => 'Participant::Base'
  belongs_to :other, :class_name => 'Participant::Base'  # other here is klu-offerer
  belongs_to :video_session
  
  attr_accessible :user_id, :other_id, :video_session_id, :url 
  
  validates_presence_of :url, :video_session_id, :other_id, :user_id
  
  after_create :generate_push_notification
  
  private
  
  def generate_push_notification
    begin
      if user.class.name == Participant::Registered
        PrivatePub.publish_to("/notifications/#{user.user_id}", "alert('call accepted!');")
      else
        PrivatePub.publish_to("/notifications/#{user.user_cookie_session_id}", "alert('call accepted!');")
      end
    rescue Exception => e
      self.logger.error("Notification::CallAccepted#generate_push_notification - error: #{e.inspect}")
    end  
  end
  
end