# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :registered_participant do
    user {FactoryGirl.create(:user)}
    type "RegisteredParticipant"
    video_session {FactoryGirl.create(:video_session_with_participants)}
    video_session_role "publisher"
  end
end
