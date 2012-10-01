# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :notification_basis, :class => 'Notification::Base' do
    
    factory :notification_incoming_call, :class => 'Notification::IncomingCall' do
      type 'Notification::IncomingCall'
      video_session_id 1
      user_id 23
      other_id 'safd34h43l24'
    end
    
    factory :notification_call_accepted, :class => 'Notification::CallAccepted' do
      type 'Notification::CallAccepted'
      url 'http://www.a.kluuu.com'
      video_session_id 1
      other_id 43
      user_id 'safd34h43l24'
    end
    
    factory :notification_call_rejected, :class => 'Notification::CallRejected' do
      type 'Notification::CallRejected'
      video_session_id 1
      other_id 43
      user_id 'safd34h43l24'
    end
    
    factory :notification_new_follower, :class => 'Notification::NewFollower' do
      type 'Notification::NewFollower'
      user_id 23
      other_id 43
    end
    
    factory :notification_new_message, :class => 'Notification::NewMessage' do
      type 'Notification::NewMessage'
      user_id 23
      content "MyText"
      other_id 43  
    end
    
  end
  
end
