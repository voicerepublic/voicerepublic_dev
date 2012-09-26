class RegisteredParticipant < Participant
  belongs_to :user
  
  attr_accessible :last_pay_tick_timestamp, :pay_tick_counter, :payment_started_timestamp, :payment_stopped_timestamp, :time_online, :user_id
  
  validates_presence_of :user_id
  
end
