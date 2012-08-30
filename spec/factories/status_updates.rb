# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :status_update do
    content "MyText"
    user_id 1
  end
end
