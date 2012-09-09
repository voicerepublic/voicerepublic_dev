# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :bookmark do
    klu_id 1
    user_id 1
    description "MyText"
  end
end
