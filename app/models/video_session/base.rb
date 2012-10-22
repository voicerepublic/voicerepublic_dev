class VideoSession::Base < ActiveRecord::Base
  attr_accessible :begin_timestamp, :end_timestamp, :klu_id, :video_system_session_id, :calling_user_id
  attr_accessor :calling_user_id
  
  belongs_to :klu, :inverse_of => :video_sessions
  
  validates_presence_of :klu, :calling_user_id

end