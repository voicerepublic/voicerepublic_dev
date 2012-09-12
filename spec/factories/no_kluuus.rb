FactoryGirl.define do
  factory :no_kluuu do
    
    #description Faker::Lorem.paragraphs(2).join("\n")
    #available_at_times "always when online"
    
    sequence :title do |t|
      "#{Faker::Lorem.sentence} #{t}"
    end
    
    user
    category
    
    factory :unpublished_no_kluuu do
      published false
    end
    factory :published_no_kluuu do
      published true
    end    
  end
end