class Participant::HostRegistered < Participant::Base
  
  belongs_to :video_session, :class_name => 'VideoSession::Registered'
  belongs_to :user
  
  attr_accessible :user_id
  
  validates_presence_of :user_id
  
  def create_link(video_room)
    self.room_url = video_room.join_url(self.user.firstname, self.video_session_role.to_sym, self.user_id)
  end
end
