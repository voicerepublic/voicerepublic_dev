# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :anonymous_participant do
    user_cookie_session_id "MyString"
  end
end
