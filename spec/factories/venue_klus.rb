# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :venue_klu do
    association :venue, factory: :venue
    association :klu, factory: :published_no_kluuu
    
    factory :venue_no_kluuu do
      association :klu, factory: :published_no_kluuu
    end
    
    factory :venue_kluuu do
      association :klu, factory: :published_kluuu
    end
    
  end
end
