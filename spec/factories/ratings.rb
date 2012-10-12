# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :rating do
    association :rateable, factory: :published_kluuu
    #rateable_type "Klu"
    user 
    content "MyText"
    score 3
  end
end
