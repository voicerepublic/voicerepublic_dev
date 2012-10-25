class VideoSession::Base < ActiveRecord::Base
  attr_accessible :begin_timestamp, :end_timestamp, :klu_id, :video_system_session_id, :calling_user_id, :type, :canceling_participant_id
  attr_accessor :calling_user_id
  attr_accessor :canceling_participant_id
  
  has_many :notifications, :class_name => 'Notification::Base', :foreign_key => 'video_session_id'
  has_one :video_room, :foreign_key => 'video_session_id', :dependent => :delete
   
  belongs_to :klu, :inverse_of => :video_sessions
    
  validates_presence_of :klu 
  validates_presence_of :calling_user_id, :on => :create

end