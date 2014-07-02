# Read about factories at https://github.com/thoughtbot/factory_girl
require 'faker'

include ActionDispatch::TestProcess

FactoryGirl.define do

  factory :venue do
    tag_list    'some, tags'
    teaser      'Some teaser not longer than 140 chars'
    description Faker::Lorem.paragraphs(2).join("\n")
    title       Faker::Lorem.sentence
    user
  end

  factory :user do
    email { Faker::Internet.email }
    firstname { Faker::Name.first_name }
    lastname { Faker::Name.last_name }
    available "online"
    last_request_at {Time.now}
    secret = "mysecret"
    password secret
    password_confirmation secret
    timezone 'Berlin'
  end

  factory :comment do
    content { Faker::Lorem.paragraph }
    user
    association :commentable, factory: :venue
  end

  factory :participation do
    venue
    user
  end

  factory :talk do
    title "MyString"
    venue
    # NOTE: times set here are not affected by `Timecop.freeze` in a
    # `before` block
    starts_at_time 1.hour.from_now.strftime('%H:%M')
    starts_at_date 1.hour.from_now.strftime('%Y-%m-%d')
    duration 60
    collect false
    tag_list 'lorem, ipsum, dolor'
    description 'talk description'
    language 'en'
  end

  factory :appearance do
    user
    talk
  end

  factory :message do
    user
    talk
    content "MyText"
  end

  factory :setting do
    key "MyString"
    value "MyString"
  end

end
