# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    email "MyString"
    firstname "MyString"
    lastname "MyString"
    encrypted_password "MyString"
  end
end
