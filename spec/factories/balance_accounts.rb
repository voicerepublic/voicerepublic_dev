# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :balance_account, :class => 'Balance::Account' do
    currency "EUR"
    balance_cents 25000
    revenue_cents 0
    user
  end
end
