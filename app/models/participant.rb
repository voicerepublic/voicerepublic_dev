class Participant < ActiveRecord::Base
  attr_accessible :entered_timestamp, :left_timestamp, :room_url, :type, :video_session_id, :video_session_role
end
