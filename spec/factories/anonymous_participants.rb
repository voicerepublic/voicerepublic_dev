# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :anonymous_participant do
    type "AnonymousParticipant"
    video_session_id 1
    video_session_role "publisher"
    user_cookie_session_id "0815participant"
  end
end
