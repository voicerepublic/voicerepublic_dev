class Notification::NewFollower < Notification::Base 
  belongs_to :other, :class_name => 'User'
  
  validates :other_id, :presence => true
  
  after_create :generate_push_notification
  
  private
  
  def generate_push_notification
    begin
      PrivatePub.publish_to("/notifications/#{user.id}", "alert('someone follows you now!');")
    rescue Exception => e
      self.logger.error("Notification::NewFollower#generate_push_notification - error: #{e.inspect}")
    end  
    
  end
end