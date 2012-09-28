class VideoSession < ActiveRecord::Base
  
  has_many :participants, :autosave => true
  belongs_to :klu
  
  attr_accessible :begin_timestamp, :end_timestamp, :klu_id, :video_system_session_id
  
  validates_associated :participants
  validates_presence_of :klu_id
  
end
