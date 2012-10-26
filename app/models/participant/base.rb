class Participant::Base < ActiveRecord::Base
  
  attr_accessible :entered_timestamp, :left_timestamp, :room_url, :type, :video_session_id, :video_session_role
  
  scope :guest, where("video_session_role=?", 'guest')
  scope :host, where("video_session_role=?", 'host')
  
  validates_presence_of :type, :video_session_role, :video_session_id
    
end
