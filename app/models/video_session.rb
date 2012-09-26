class VideoSession < ActiveRecord::Base
  
  has_many :participants
  
  attr_accessible :begin_timestamp, :end_timestamp, :offer_id, :video_system_session_id
  
  validates_presence_of :offer_id
  validate :has_two_participants
  
  def has_two_participants
    if self.participants.count != 2
      errors.add(:participants, "two participants necessary")
    end
  end
  
end
