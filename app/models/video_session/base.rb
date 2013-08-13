# Attributes:
# * id [integer, primary, not null] - primary key
# * begin_timestamp [datetime] - TODO: document me
# * created_at [datetime, not null] - creation time
# * end_timestamp [datetime] - TODO: document me
# * klu_id [integer] - belongs to :klu
# * type [string] - TODO: document me
# * updated_at [datetime, not null] - last update time
# * video_system_session_id [string] - TODO: document me
class VideoSession::Base < ActiveRecord::Base
  attr_accessible :begin_timestamp, :end_timestamp, :klu_id,:klu, :video_system_session_id, :calling_user_id, :type, :canceling_participant_id
  attr_accessor :calling_user_id
  attr_accessor :canceling_participant_id
  
  has_many :notifications, :class_name => 'Notification::Base', :foreign_key => 'video_session_id'
  has_one :video_room, :autosave => true, :foreign_key => 'video_session_id', :dependent => :delete
  #belongs_to :klu, :inverse_of => :video_sessions
    
  #validates_presence_of :klu 
  validates_presence_of :calling_user_id, :on => :create
  
  
  def is_rateable?
    self.instance_of?(VideoSession::Registered) && self.klu.instance_of?(Kluuu) && enough_time_passed?
  end
  
  private
  
  # enough time to create a rating?
  #
  def enough_time_passed?
    p = self.guest_participant
    Rails.logger.info("#{self.class.name}#enough_time_passed? - guest: #{p.inspect}")
    if  p.left_timestamp.nil?
      Rails.logger.error("#{self.class.name}#enough_time_passed? - ERROR - no left_timestamp available")
      # FIXME - check why there is no left-timestamp - until then use Time.now
      ( Time.now - p.entered_timestamp ) >= 3.minutes
    else
      ( p.left_timestamp - p.entered_timestamp ) >= 3.minutes
    end
  end

end
