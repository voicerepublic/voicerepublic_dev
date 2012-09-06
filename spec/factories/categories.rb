# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :category do
    name { Faker::Lorem.words(1)}
  end
  
  factory :child_category, :class => Category do
    _category = 
    name { Faker::Lorem.words(1)}
    parent_id { FactoryGirl.create(:category).id }
  end
end
