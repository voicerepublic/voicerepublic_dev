# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :video_room do
    video_server_id 1
    video_session_id 1
    video_system_room_id "sfasdasfag45k4lk"
    name "MyVideoRoom"
    welcome_msg "Spass"
  end
end
