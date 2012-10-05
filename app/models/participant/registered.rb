class Participant::Registered < Participant::Base
  attr_accessible :last_pay_tick_timestamp, :pay_tick_counter, :payment_started_timestamp, :payment_stopped_timestamp, :time_online, :user_id
  
  belongs_to :user
  
  validates_presence_of :user_id
end
