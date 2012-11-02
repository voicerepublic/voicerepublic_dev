class Notification::VideoSystemError < Notification::Base 
  
  belongs_to :user
  belongs_to :other, :class_name => 'User'  # other here is klu-offerer
  belongs_to :video_session, :class_name => 'VideoSession::Base'
  
  attr_accessible :other_id, :video_session_id, :user_id, :anon_id
  
  validates_presence_of :video_session_id, :other_id
  validates_presence_of :user_id, :if => Proc.new { |n| n.anon_id.nil? }, :message => 'user_id is missing'
  validates_presence_of :anon_id, :if => Proc.new { |n| n.other_id.nil? }, :message => 'anon_id is missing'
  
  
  after_create :generate_push_notification
  
  private
  
  def generate_push_notification
    begin
      n = NotificationRenderer.new
      if self.anon_id.nil?
        PrivatePub.publish_to("/notifications/#{self.user_id}", n.render('notifications/video_system_error'))
      else
        PrivatePub.publish_to("/notifications/#{self.anon_id}", n.render('notifications/video_system_error'))
      end
    rescue Exception => e
      self.logger.error("Notification::VideoSystemError#generate_push_notification - error: #{e.inspect}")
    end  
  end  

end