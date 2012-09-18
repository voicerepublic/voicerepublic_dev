# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :message do
    receiver_id 1
    sender_id 1
    content "MyText"
    read false
  end
end
