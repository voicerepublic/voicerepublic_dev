# Read about factories at https://github.com/thoughtbot/factory_girl
require 'faker'

FactoryGirl.define do
  factory :comment do
    content { Faker::Lorem.paragraph }
    association :commentable, factory: :status_update
    user
  end
end
