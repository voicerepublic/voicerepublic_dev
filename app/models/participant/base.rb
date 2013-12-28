class Participant::Base < ActiveRecord::Base
  
  attr_accessible :entered_timestamp, :left_timestamp, :room_url, :type, :video_session_id, :video_session_role
  attr_accessible :last_pay_tick_timestamp, :pay_tick_counter, :payment_started_timestamp, :payment_stopped_timestamp, :seconds_online, :user_id
  
  
  scope :guest, where("video_session_role=?", 'guest')
  scope :host, where("video_session_role=?", 'host')
  
  validates_presence_of :type, :video_session_role, :video_session_id
    
end
