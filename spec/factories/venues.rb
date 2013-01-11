# Read about factories at https://github.com/thoughtbot/factory_girl
require 'faker'

FactoryGirl.define do
  factory :venue do
    association :host_kluuu, factory: :published_kluuu
    start_time Time.now + 1.week
    description Faker::Lorem.paragraphs(2)
    title Faker::Lorem.sentence
    intro_video "MyString"
    
    after(:create) do |venue|
      FactoryGirl.create_list(:venue_klu, 3, :venue => venue)
    end
   
  end
end
