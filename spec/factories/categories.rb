# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :category do
    name { Faker}
    parent_id 1
    lft 1
    rgt 1
  end
end
