FactoryGirl.define do
  factory :kluuu do

    description Faker::Lorem.paragraphs(2).join("\n")
    available_at_times "always when online"
    user
    category

    sequence :title do |t|
      "#{Faker::Lorem.sentence} #{t}"
    end

    trait :unpublished_kluuu do
      published false
    end
    
    trait :published_kluuu do
      published true
    end

    trait :kluuu_with_image do
      klu_images { [  File.open( File.join(Rails.root,'app','assets', 'images', 'rails.png')) ] }
    end

    factory :unpublished_kluuu, traits: [:unpublished_kluuu]
    factory :published_kluuu, traits: [:published_kluuu]
  
    factory :kluuu_with_image do
      after(:create) do |kluuu, evaluator|
        FactoryGirl.create(:klu_image, :kluuu => kluuu)
      end
    end
  end

end