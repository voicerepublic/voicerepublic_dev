class RegisteredParticipant < Participant
  attr_accessible :last_pay_tick_timestamp, :pay_tick_counter, :payment_started_timestamp, :payment_stopped_timestamp, :time_online, :user_id
end
