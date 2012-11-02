class Notification::MissedCall < Notification::Base 
  
  belongs_to :user
  belongs_to :other, :class_name => 'User'  # other may be nil in case of anonymous call?
  belongs_to :video_session, :class_name => 'VideoSession::Base'
  
  attr_accessible :user_id, :other_id, :anon_id, :video_session_id, :url
  
  #other_id can be a session id of the cookie in case an anonymous user calls
  #validates_presence_of :user_id, :video_session_id
  #validates_presence_of :other_id, :if => Proc.new { |n| n.anon_id.nil? }, :message => 'other_id is missing'
  #validates_presence_of :url, :if => Proc.new { |n| n.anon_id.nil? }, :message => 'url is missing'
  #validates_presence_of :anon_id, :if => Proc.new { |n| n.other_id.nil? }, :message => 'anon_id is missing'
  
  after_create :generate_push_notification
  
  def to_s
    I18n.t('.you_missed_a_call_on_your_klu', :caller => other ? other.name : 'anonymous')
  end
  
  def generate_push_notification
    begin
      n = KluuuCode::NotificationRenderer.new
      PrivatePub.publish_to("/notifications/#{user_id}", n.render('notifications/missed_call'))
    rescue Exception => e
      self.logger.error("#{self.class.name}#generate_push_notification - error: #{e.inspect}")
    end  
  end
  
end