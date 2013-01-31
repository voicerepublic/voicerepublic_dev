# Read about factories at https://github.com/thoughtbot/factory_girl
require 'faker'

FactoryGirl.define do
  factory :venue do
    association :host_kluuu, factory: :published_kluuu
    start_time Time.now + 1.week
    description Faker::Lorem.paragraphs(2)
    title Faker::Lorem.sentence
    intro_video "MyString"
    duration 90
    repeating 0
    
    after(:create) do |venue|
      FactoryGirl.create_list(:venue_klu, 3, :venue => venue)
    end
    
    trait :repeating_venue do
      repeating 1
    end
    
   
    factory :repeating_venue, traits: [:repeating_venue] 
   
  end
end
