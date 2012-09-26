class Participant < ActiveRecord::Base
  
  belongs_to :video_session
  
  attr_accessible :entered_timestamp, :left_timestamp, :room_url, :type, :video_session_id, :video_session_role
  
  validates_presence_of :type, :video_session_role, :video_session_id
  
end
