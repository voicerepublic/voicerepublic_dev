# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :profile_setting do
    timezone "MyString"
    language_1 "MyString"
    language_2 "MyString"
    language_3 "MyString"
    user_id 1
  end
end
