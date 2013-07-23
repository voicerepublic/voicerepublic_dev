# Attributes:
# * id [integer, primary, not null] - primary key
# * created_at [datetime, not null] - creation time
# * entered_timestamp [datetime] - TODO: document me
# * last_pay_tick_timestamp [datetime] - TODO: document me
# * left_timestamp [datetime] - TODO: document me
# * pay_tick_counter [integer, default=0] - TODO: document me
# * payment_started_timestamp [datetime] - TODO: document me
# * payment_stopped_timestamp [datetime] - TODO: document me
# * room_url [string] - TODO: document me
# * seconds_online [integer, default=0] - TODO: document me
# * type [string] - TODO: document me
# * updated_at [datetime, not null] - last update time
# * user_cookie_session_id [string] - TODO: document me
# * user_id [integer] - TODO: document me
# * video_session_id [integer] - belongs to :video_session
# * video_session_role [string] - TODO: document me
class Participant::GuestAnonymous < Participant::Base
  
  belongs_to :video_session, :class_name => 'VideoSession::Anonymous'
  
  attr_accessible :user_cookie_session_id
  
  validates_presence_of :user_cookie_session_id
  
  def create_link(video_room)
    self.room_url = video_room.join_url('Anonymous', self.video_session_role.to_sym, self.user_cookie_session_id)
  end
end
