class VideoSession < ActiveRecord::Base
  attr_accessible :begin_timestamp, :end_timestamp, :offer_id, :video_system_session_id
end
