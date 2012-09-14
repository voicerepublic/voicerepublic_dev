# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :follow do
    association :follower, factory: :user
    association :followed, factory: :user
  end
end
