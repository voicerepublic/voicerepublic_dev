# Read about factories at https://github.com/thoughtbot/factory_girl
require 'faker'

include ActionDispatch::TestProcess

FactoryGirl.define do

  # basic models

  # factory :event do
  #   start_time 1.week.ago
  #   duration   90
  #   #association :venue
  #   venue
  #   title      "Spec event title"
  # end

  factory :venue do
    tag_list    'some, tags'
    teaser      Faker::Lorem.paragraph
    description Faker::Lorem.paragraphs(2).join("\n")
    title       Faker::Lorem.sentence
    user

    # factory :venue_with_events do
    #   ignore do
    #     events_count 3
    #   end
    #   after(:build) do |venue, evaluator|
    #     evaluator.events_count.times do |i|
    #       venue.events << FactoryGirl.create(:event)
    #     end
    #   end
    # end
  end

  factory :account do
    timezone { ActiveSupport::TimeZone.all[rand(ActiveSupport::TimeZone.all.length)].name }
    language_1 "DE"
    language_2 "EN"
    language_3 "FR"
    user

    factory :account_with_portrait do
      portrait { fixture_file_upload( File.join(Rails.root,'app','assets', 'images', 'rails.png')) }
    end

    factory :account_with_prefs do
      prefs { {
          :anonymous_calls => "1",
          :email_concerning_me => "1",
          :email_concerning_other => "1",
          :inform_of_friends => "1",
          :no_initial_help => "1"
        } }
    end
  end

  factory :article do
    venue
    content "MyText"
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
    # trait :with_portrait do
    #   association :account, factory: :account_with_portrait
    # end
    #factory :user_with_portrait, traits: [:with_portrait]
  end

  factory :comment do
    content { Faker::Lorem.paragraph }
    article
    user
  end

  factory :participation do
    venue
    user
  end

  factory :talk do
    title "MyString"
    venue
    starts_at 1.hour.from_now.strftime('%Y-%m-%d %H:%M')
    # ends_at   2.hour.from_now
    # ended_at 90.minutes.from_now
    duration 60
    record false
    # recording "MyString"
    tag_list 'lorem, ipsum, dolor'
    description 'talk description'
  end

  factory :message do
    user 
    talk
    content "MyText"
  end
end
