FactoryGirl.define do
  factory :kluuu do
    
    description Faker::Lorem.paragraphs(2).join("\n")
    available_at_times "always when online"
    
    sequence :title do |t|
      "#{Faker::Lorem.sentence(4)} #{t}"
    end
    
    user
    category
    
    factory :unpublished_kluuu do
      published false
    end
    factory :published_kluuu do
      published true
    end
    
  end
  
end