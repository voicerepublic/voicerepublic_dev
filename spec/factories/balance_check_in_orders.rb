# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :balance_check_in_order, :class => 'Balance::CheckInOrder' do
    credit_account_id 1
    completed false
    completed_at "2012-10-15 17:18:39"
    currency "MyString"
    amount 1
  end
end
