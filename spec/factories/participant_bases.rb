# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :participant_basis, :class => 'Participant::Base' do

    factory :guest_participant_registered, :class => 'Participant::GuestRegistered' do
      association :user, factory: :user
      type "Participant::GuestRegistered"
      video_session_id 1
      video_session_role "guest"
    end
    
    factory :host_participant, :class => 'Participant::HostRegistered' do
      association :user, factory: :user
      type "Participant::HostRegistered"
      video_session_id 1
      video_session_role "host"
    end

    factory :guest_participant_anonymous, :class => 'Participant::GuestAnonymous' do
      type "Participant::GuestAnonymous"
      video_session_id 1
      video_session_role "guest"
      user_cookie_session_id "0815participant"
    end

  end
end
