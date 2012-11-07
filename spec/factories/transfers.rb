# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :transfer do
    account_id 1
    video_session_id 1
    duration 1
    transfer_charge_cents 1
    transfer_charge_currency "MyString"
    transfer_gross_cents 1
    transfer_gross_currency "MyString"
    video_session_charge_cents 1
    video_session_charge_currency "MyString"
    exchange_rate "9.99"
    video_session_klu_name "MyString"
  end
end
