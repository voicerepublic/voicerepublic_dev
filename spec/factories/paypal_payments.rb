# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :paypal_payment do
    params "MyText"
    check_in_order_id 1
    status "MyString"
    amount_cents 1
    tact_id "MyString"
    currency "MyString"
  end
end
