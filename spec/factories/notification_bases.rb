# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :notification_basis, :class => 'Notification::Base' do
    user
    content "MyText"
    
    factory :notification_incoming_call do
      type 'Notification::IncomingCall'
    end
    
  end
  
end
