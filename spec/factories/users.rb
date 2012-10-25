# Read about factories at https://github.com/thoughtbot/factory_girl
require 'faker'

FactoryGirl.define do
  factory :user do
    email { Faker::Internet.email }
    firstname { Faker::Name.first_name }
    lastname { Faker::Name.last_name }
    available "online"
    last_request_at {Time.now}
    secret = "mysecret"
    password secret
    password_confirmation secret
    trait :user_with_portrait do
      portrait File.open(File.join(Rails.root,'app','assets','images','rails.png'))
    end 
    factory :admin do
      # TODO: create factory for role and user_role
      # roles [Role.find_by_name('user'), Role.find_by_name('admin')]
    end
    factory :user_with_portrait, traits: [:user_with_portrait]
  end
end
