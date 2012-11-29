FactoryGirl.define do
  factory :kluuu do

    description Faker::Lorem.paragraphs(2).join("\n")
    available_at_times "always when online"
    association :user
    category
    currency 'EUR'
    charge_cents 0
    tag_list "foo, bar, baz"
    
    sequence :title do |t|
      "#{Faker::Lorem.sentence} #{t}"
    end

    trait :unpublished_kluuu do
      published false
    end
    
    trait :published_kluuu do
      published true
    end

    factory :unpublished_kluuu, traits: [:unpublished_kluuu]
    factory :published_kluuu, traits: [:published_kluuu]
  
    factory :kluuu_with_image do
      after(:create) do |kluuu, evaluator|
        FactoryGirl.create(:klu_image, :kluuu => kluuu)
      end
    end
    
    factory :bookmarked_kluuu do
      after(:create) do |kluuu,evaluator|
        FactoryGirl.create_list(:kluuu_bookmark, 3, :kluuu => kluuu)
      end
    end
    
  end

end