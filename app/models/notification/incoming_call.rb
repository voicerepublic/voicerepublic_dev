class Notification::IncomingCall < Notification::Base 
  
  belongs_to :user
  belongs_to :other, :class_name => 'User'  # other here is klu-owner
  belongs_to :video_session
  
  attr_accessible :user_id, :other_id, :anon_id, :video_session_id
  
  #other_id can be a session id of the cookie in case an anonymous user calls
  validates_presence_of :user_id, :video_session_id
  validates_presence_of :other_id, :if => Proc.new { |n| n.anon_id.nil? }
  validates_presence_of :anon_id, :if => Proc.new { |n| n.other_id.nil? }
  
  after_create :generate_push_notification
  
  def to_s
    I18n.t('.incoming_call', :caller => other ? other.name : 'anonymous')
  end
  
  private
  
  def generate_push_notification
    begin
      PrivatePub.publish_to("/notifications/#{user_id}", "alert(<%= self.to_s %>);")
    rescue Exception => e
      self.logger.error("#{self.class.name}#generate_push_notification - error: #{e.inspect}")
    end  
  end
  
end