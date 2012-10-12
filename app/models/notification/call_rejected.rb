class Notification::CallRejected < Notification::Base 
  
  belongs_to :user
  belongs_to :other, :class_name => 'User'  # other here is klu-offerer
  belongs_to :video_session
  
  attr_accessible :other_id, :video_session_id, :user_id, :anon_id
  
  validates_presence_of :video_session_id, :other_id
  validates_presence_of :user_id, :if => Proc.new { |n| n.anon_id.nil? }
  validates_presence_of :anon_id, :if => Proc.new { |n| n.other_id.nil? }
  
  
  after_create :generate_push_notification
  
  private
  
  def generate_push_notification
    begin
      if self.anon_id.nil?
        PrivatePub.publish_to("/notifications/#{self.user_id}", "alert('call rejected!');")
      else
        PrivatePub.publish_to("/notifications/#{self.anon_id}", "alert('call rejected!');")
      end
    rescue Exception => e
      self.logger.error("Notification::CallAccepted#generate_push_notification - error: #{e.inspect}")
    end  
  end  

end