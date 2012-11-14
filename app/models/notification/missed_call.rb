class Notification::MissedCall < Notification::Base 
  
  belongs_to :user
  belongs_to :other, :class_name => 'User'  # other may be nil in case of anonymous call?
  belongs_to :video_session, :class_name => 'VideoSession::Base'
  belongs_to :klu
  
  attr_accessible :user_id, :other_id, :anon_id, :video_session_id, :url, :klu_id
  validates :klu_id, :presence => true
  #other_id can be a session id of the cookie in case an anonymous user calls
  #validates_presence_of :user_id, :video_session_id
  #validates_presence_of :other_id, :if => Proc.new { |n| n.anon_id.nil? }, :message => 'other_id is missing'
  #validates_presence_of :url, :if => Proc.new { |n| n.anon_id.nil? }, :message => 'url is missing'
  #validates_presence_of :anon_id, :if => Proc.new { |n| n.other_id.nil? }, :message => 'anon_id is missing'
  
  after_create :generate_push_notification
  after_create :generate_mail_notification
  
  def to_s
    I18n.t('.you_missed_a_call_on_your_klu', :caller => other ? other.name : 'anonymous')
  end
  
  def generate_push_notification
    begin
      n = KluuuCode::NotificationRenderer.new
      PrivatePub.publish_to("/notifications/#{user_id}", n.render('notifications/missed_call', :locals => {:user_id => self.user_id, :count => self.user.notifications.alerts.unread.count}))
    rescue Exception => e
      Rails.logger.error("#{self.class.name}#generate_push_notification - error: #{e.inspect}")
    end  
  end
  
end