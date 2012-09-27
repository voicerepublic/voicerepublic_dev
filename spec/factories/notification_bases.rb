# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :notification_basis, :class => 'Notification::Base' do
    user_id 1
    content "MyText"
  end
end
