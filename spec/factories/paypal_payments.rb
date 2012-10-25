# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :paypal_payment do
    params "{1=>2}"
    association :check_in_order, factory: :balance_check_in_order
    status "MyString"
    amount_cents { check_in_order ? check_in_order.amount_cents : 0 }
    tact_id "adsfasdfasdfa"
    currency { check_in_order ? check_in_order.currency : "EUR" }
  end
end
