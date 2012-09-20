# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :message do
    association :receiver, factory: :user
    association :sender, factory: :user
    
    #association :sender_conversation, factory: :conversation
    #association :receiver_conversation, factory: :conversation
    
    content { Faker::Lorem.paragraph }
  end
end
