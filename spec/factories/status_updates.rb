# Read about factories at https://github.com/thoughtbot/factory_girl
require 'faker'

FactoryGirl.define do
  factory :status_update do
    content Faker::Lorem.paragraph
    user
  end
end
