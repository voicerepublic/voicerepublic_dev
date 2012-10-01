# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :notification_basis, :class => 'Notification::Base' do
    user
    content "MyText"
    
    factory :notification_incoming_call do
      type 'Notification::IncomingCall'
      klu
    end
    
    factory :notification_new_follower, :class => 'Notification::NewFollower' do
      type 'Notification::NewFollower'
      association :other, factory: :user
    end
    
    factory :notification_new_message, :class => 'Notification::NewMessage' do
      type 'Notification::NewMessage'
      association :other, factory: :user
    end
    
  end
  
end
