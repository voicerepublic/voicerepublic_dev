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
    
    #after(:create) do |venue|
    #  FactoryGirl.create_list(:venue_klu, 2, :venue => venue)
    #end
    
    trait :repeating_venue do
      repeating 1
    end
    
    
    trait :with_venue_klus do
      
      after(:create) do |venue|
        FactoryGirl.create_list(:venue_klu, 2, :venue => venue)
      end
  
    end
    
   
    factory :repeating_venue, traits: [:repeating_venue] 
    factory :venue_with_klus, traits: [:with_venue_klus]
   
  end
end
