# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :message do
    association :receiver, factory: :user
    association :sender, factory: :user
    content { Faker::Lorem.paragraph }
  end
end
