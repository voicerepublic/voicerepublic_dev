class Notification::CallEnded < Notification::Base 
 
  belongs_to :user
  belongs_to :other, :class_name => 'User'  # other here is klu-offerer
  belongs_to :video_session, :class_name => 'VideoSession::Base'
  
  attr_accessible :user_id, :video_session_id, :anon_id
  
  validates_presence_of :video_session_id
  
  after_create :generate_push_notification
  
  private
  
  def generate_push_notification
    begin
      n = KluuuCode::NotificationRenderer.new
      if self.anon_id.nil?
        PrivatePub.publish_to("/notifications/#{self.user_id}", n.render('notifications/call_ended'))
      else
        PrivatePub.publish_to("/notifications/#{self.anon_id}", n.render('notifications/call_ended'))
      end
    rescue Exception => e
      self.logger.error("Notification::CallEnded#generate_push_notification - error: #{e.inspect}")
    end  
  end
  
end