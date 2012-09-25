# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :registered_participant do
    user_id 1
    time_online 1
    last_pay_tick_timestamp "2012-09-25 16:15:51"
    pay_tick_counter 1
    payment_started_timestamp "2012-09-25 16:15:51"
    payment_stopped_timestamp "2012-09-25 16:15:51"
  end
end
