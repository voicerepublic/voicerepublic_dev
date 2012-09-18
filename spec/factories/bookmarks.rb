# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :bookmark do
    user
    
    trait :no_kluuu_bookmark do
      no_kluuu
    end
    
    trait :kluuu_bookmark do
      kluuu
    end
    
    factory :no_kluuu_bookmark, traits: [:no_kluuu_bookmark]
    factory :kluuu_bookmark, :traits => [:kluuu_bookmark]
  end
  
end
