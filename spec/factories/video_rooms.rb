# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :video_room do
    sequence(:video_server_id) { |n| n } 
    sequence(:video_session_id) { |n| n } 
    sequence(:video_system_room_id) { |n| "sfasdasfag45k4lk#{n}" }
    guest_password { Faker::Lorem.characters(16) }
    host_password { Faker::Lorem.characters(16) }
    name { Faker::Name.name }
    welcome_msg "Viel Spass"
  end
  factory :video_room_without_system_id, class: VideoRoom do
    sequence(:video_server_id) { |n| n } 
    sequence(:video_session_id) { |n| n } 
    guest_password { Faker::Lorem.characters(16) }
    host_password { Faker::Lorem.characters(16) }
    name { Faker::Name.name }
    welcome_msg "Viel Spass"
  end
end
