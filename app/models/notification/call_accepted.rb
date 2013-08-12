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
class Notification::CallAccepted < Notification::Base 
  attr_accessible :user_id, :other_id, :video_session_id, :url, :anon_id, :other, :user
  
  belongs_to :user
  belongs_to :other, :class_name => 'User'  # other here is klu-offerer
  belongs_to :video_session, :class_name => 'VideoSession::Base'
  #belongs_to :klu
  
  
  
  validates_presence_of :video_session_id, :other_id#, :klu_id
  validates_presence_of :user_id, :if => Proc.new { |n| n.anon_id.nil? }
  validates_presence_of :anon_id, :if => Proc.new { |n| n.other_id.nil? }
  
  after_create :generate_push_notification
  
  private
  
  def generate_push_notification
    begin
      n = KluuuCode::NotificationRenderer.new
      if self.anon_id.nil?
        PrivatePub.publish_to("/notifications/#{self.user_id}", n.render('notifications/call_accepted', :locals => {:video_session => self.video_session}))
      else
        PrivatePub.publish_to("/notifications/#{self.anon_id}", n.render('notifications/call_accepted', :locals => {:video_session => self.video_session}))
      end
    rescue Exception => e
      Rails.logger.error("Notification::CallAccepted#generate_push_notification - error: #{e.inspect}")
    end  
  end
  
end
