# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :paypal_payment do
    params "{1=>2}"
    association :check_in_order, factory: :balance_check_in_order
    status "MyString"
    amount { check_in_order ? check_in_order.amount : 10 }
    tact_id "adsfasdfasdfa"
    currency { check_in_order ? check_in_order.currency : "EUR" }
  end
end
