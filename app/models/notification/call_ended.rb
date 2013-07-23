# Attributes:
# * id [integer, primary, not null] - primary key
# * anon_id [string] - TODO: document me
# * content [text] - TODO: document me
# * created_at [datetime, not null] - creation time
# * klu_id [integer] - TODO: document me
# * other_id [integer] - belongs to :other
# * read [boolean] - TODO: document me
# * type [string] - TODO: document me
# * updated_at [datetime, not null] - last update time
# * url [string] - TODO: document me
# * user_id [integer] - belongs to :user
# * video_session_id [integer] - belongs to :video_session
class Notification::CallEnded < Notification::Base 
 
  belongs_to :user
  belongs_to :other, :class_name => 'User'  # other here is klu-offerer
  belongs_to :video_session, :class_name => 'VideoSession::Base'
  
  attr_accessible :user_id, :video_session_id, :anon_id
  
  validates_presence_of :video_session_id
  
  after_create :generate_push_notification
  after_create :generate_make_rate_notification
  
  private
  
  def generate_push_notification
    begin
      n = KluuuCode::NotificationRenderer.new
      if self.anon_id.nil? #registered user
        PrivatePub.publish_to("/notifications/#{self.user_id}", n.render('notifications/call_ended', :locals => {:video_session => self.video_session, :user => self.user }))
      else #unregistered user
        PrivatePub.publish_to("/notifications/#{self.anon_id}", n.render('notifications/call_ended', :locals => {:video_session => self.video_session, :user => nil }))
      end
    rescue Exception => e
      Rails.logger.error("Notification::CallEnded#generate_push_notification - error: #{e.inspect}")
    end  
  end
  
  def generate_make_rate_notification
    vs = VideoSession::Base.find(self.video_session_id)
    if vs && vs.is_rateable?
      n = Notification::MakeRate.where("user_id = ? AND klu_id = ?", vs.guest_participant.user.id, vs.klu.id)
      if n.empty?
        Notification::MakeRate.create(
                                      :user => vs.guest_participant.user, 
                                      :other => vs.host_participant.user, 
                                      :klu => vs.klu  
                                      )
      end
      
    end
  end
  
end
