# Read about factories at https://github.com/thoughtbot/factory_girl
require 'faker'

FactoryGirl.define do
  factory :user do
    email { Faker::Internet.email }
    firstname { Faker::Name.first_name }
    lastname { Faker::Name.last_name }
    secret = "mysecret"
    password secret
    password_confirmation secret 
  end
end
