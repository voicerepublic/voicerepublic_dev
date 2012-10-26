class Participant::Registered < Participant::Base
  
  belongs_to :video_session, :class_name => 'VideoSession::Registered'
  belongs_to :user
  
  attr_accessible :last_pay_tick_timestamp, :pay_tick_counter, :payment_started_timestamp, :payment_stopped_timestamp, :time_online, :user_id
  
  validates_presence_of :user_id
  
  def create_link(video_room)
    self.room_url = video_room.join_url(self.user.firstname, self.video_session_role.to_sym, self.user_id)
  end
end
