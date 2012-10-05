# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :participant_basis, :class => 'Participant::Base' do

    factory :participant_registered, :class => 'Participant::Registered' do
      user
      type "Participant::Registered"
      video_session
      video_session_role "publisher"
    end

    factory :participant_anonymous, :class => 'Participant::Anonymous' do
      type "Participant::Anonymous"
      video_session
      video_session_role "publisher"
      user_cookie_session_id "0815participant"
    end

  end
end
