# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :participant do
    type ""
    video_session_id 1
    entered_timestamp "2012-09-25 16:08:05"
    left_timestamp "2012-09-25 16:08:05"
    room_url "MyString"
    video_session_role "MyString"
  end
end
