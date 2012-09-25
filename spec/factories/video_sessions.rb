# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :video_session do
    offer_id 1
    end_timestamp "2012-09-25 15:46:18"
    begin_timestamp "2012-09-25 15:46:18"
    video_system_session_id "MyString"
  end
end
