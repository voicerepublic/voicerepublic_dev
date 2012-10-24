class Notification::CallAccepted < Notification::Base 
 
  belongs_to :user
  belongs_to :other, :class_name => 'User'  # other here is klu-offerer
  belongs_to :video_session
  
  attr_accessible :user_id, :other_id, :video_session_id, :url, :anon_id
  
  validates_presence_of :url, :video_session_id, :other_id
  validates_presence_of :user_id, :if => Proc.new { |n| n.anon_id.nil? }
  validates_presence_of :anon_id, :if => Proc.new { |n| n.other_id.nil? }
  
  after_create :generate_push_notification
  
  private
  
  def generate_push_notification
    begin
      n = NotificationRenderer.new
      if self.anon_id.nil?
        PrivatePub.publish_to("/notifications/#{self.user_id}", n.render('notifications/call_accepted'))
      else
        PrivatePub.publish_to("/notifications/#{self.anon_id}", n.render('notifications/call_accepted'))
      end
    rescue Exception => e
      self.logger.error("Notification::CallAccepted#generate_push_notification - error: #{e.inspect}")
    end  
  end
  
end