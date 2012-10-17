# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :balance_account, :class => 'Balance::Account' do
    currency "MyString"
    prepaid_cents 1
    revenue_cents 1
    user_id 1
  end
end
