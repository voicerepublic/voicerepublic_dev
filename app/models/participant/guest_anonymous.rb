class Participant::GuestAnonymous < Participant::Base
  
  belongs_to :video_session, :class_name => 'VideoSession::Anonymous'
  
  attr_accessible :user_cookie_session_id
  
  validates_presence_of :user_cookie_session_id
  
  def create_link(video_room)
    self.room_url = video_room.join_url('Anonymous', self.video_session_role.to_sym, self.user_cookie_session_id)
  end
end
