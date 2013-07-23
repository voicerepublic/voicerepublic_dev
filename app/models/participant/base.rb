# Attributes:
# * id [integer, primary, not null] - primary key
# * created_at [datetime, not null] - creation time
# * entered_timestamp [datetime] - TODO: document me
# * last_pay_tick_timestamp [datetime] - TODO: document me
# * left_timestamp [datetime] - TODO: document me
# * pay_tick_counter [integer, default=0] - TODO: document me
# * payment_started_timestamp [datetime] - TODO: document me
# * payment_stopped_timestamp [datetime] - TODO: document me
# * room_url [string] - TODO: document me
# * seconds_online [integer, default=0] - TODO: document me
# * type [string] - TODO: document me
# * updated_at [datetime, not null] - last update time
# * user_cookie_session_id [string] - TODO: document me
# * user_id [integer] - TODO: document me
# * video_session_id [integer] - TODO: document me
# * video_session_role [string] - TODO: document me
class Participant::Base < ActiveRecord::Base
  
  attr_accessible :entered_timestamp, :left_timestamp, :room_url, :type, :video_session_id, :video_session_role
  attr_accessible :last_pay_tick_timestamp, :pay_tick_counter, :payment_started_timestamp, :payment_stopped_timestamp, :seconds_online, :user_id
  
  
  scope :guest, where("video_session_role=?", 'guest')
  scope :host, where("video_session_role=?", 'host')
  
  validates_presence_of :type, :video_session_role, :video_session_id
    
end
