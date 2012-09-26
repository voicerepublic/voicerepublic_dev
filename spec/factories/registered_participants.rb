# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :registered_participant do
    user
    type "RegisteredParticipant"
    video_session
    video_session_role "publisher"
  end
end
