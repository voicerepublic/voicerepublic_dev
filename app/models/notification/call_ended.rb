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
    if self.video_session.is_rateable?
      Notification::MakeRate.create(:user => self.video_session.guest_participant.user, 
                                    :other => self.video_session.klu.user, 
                                    :klu => self.video_session.klu  )
      
    end
  end
  
end