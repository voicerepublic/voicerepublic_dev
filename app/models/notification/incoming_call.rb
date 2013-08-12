# Attributes:
# * id [integer, primary, not null] - primary key
# * anon_id [string] - TODO: document me
# * content [text] - TODO: document me
# * created_at [datetime, not null] - creation time
# * klu_id [integer] - belongs to :klu
# * other_id [integer] - belongs to :other
# * read [boolean] - TODO: document me
# * type [string] - TODO: document me
# * updated_at [datetime, not null] - last update time
# * url [string] - TODO: document me
# * user_id [integer] - belongs to :user
# * video_session_id [integer] - belongs to :video_session
class Notification::IncomingCall < Notification::Base 

  attr_accessible :user_id, :other_id, :anon_id, :video_session_id, :other  
  
  belongs_to :user
  belongs_to :other, :class_name => 'User'  # other here is klu-owner
  belongs_to :video_session, :class_name => 'VideoSession::Base'
  #belongs_to :klu
  
  #other_id can be a session id of the cookie in case an anonymous user calls
  validates_presence_of :user_id, :video_session_id#, :klu_id
  validates_presence_of :other_id, :if => Proc.new { |n| n.anon_id.nil? }
  validates_presence_of :anon_id, :if => Proc.new { |n| n.other_id.nil? }
  
  after_create :generate_push_notification
  
  def to_s
    I18n.t('.incoming_call', :caller => other ? other.name : 'anonymous')
  end
  
  private
  
  def generate_push_notification
    begin
      n = KluuuCode::NotificationRenderer.new
      PrivatePub.publish_to("/notifications/#{user_id}", n.render('notifications/incoming_call', :locals => {:video_session => self.video_session}))
    rescue Exception => e
      self.logger.error("#{self.class.name}#generate_push_notification - error: #{e.inspect}")
    end  
  end
  
end
