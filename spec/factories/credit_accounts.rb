# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :credit_account do
    user_id 1
    prepaid_amount 0
    revenue_amount 0
    currency "EUR"
  end
end
