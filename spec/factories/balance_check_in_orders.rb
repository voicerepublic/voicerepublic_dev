# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :balance_check_in_order, :class => 'Balance::CheckInOrder' do
    balance_account
    completed false
    completed_at "2012-10-15 17:18:39"
    currency "EUR"
    amount_cents 1000
    
    trait :completed_check_in_order do
      completed true
    end
    
    factory :completed_check_in_order, traits: [:completed_check_in_order]
  end
end
