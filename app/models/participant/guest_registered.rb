require 'payment'

class Participant::GuestRegistered < Participant::Base
  
  belongs_to :video_session, :class_name => 'VideoSession::Registered'
  belongs_to :user
  
  after_update :payment, :unless => Proc.new { |p| p.payment_started_timestamp.nil? || p.payment_stopped_timestamp.nil? }
  
  validates_presence_of :user_id
  
  def create_link(video_room)
    self.room_url = video_room.join_url(self.user.firstname, self.video_session_role.to_sym, self.user_id)
  end
  
  def payment
    
   video_session = self.video_session
   
   if video_session.klu.instance_of?(Kluuu)  && video_session.klu.charge_type == "fix"
     Payment::Calculation.fix_price(video_session)
   elsif video_session.klu.instance_of?(Kluuu)  && video_session.klu.charge_type == "minute"
     Payment::Calculation.minute_price(video_session)
   end
  
  end
  
end
