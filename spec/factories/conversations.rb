# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :conversation do
    association :user_1, factory: :user
    association :user_2, factory: :user
  end
end
