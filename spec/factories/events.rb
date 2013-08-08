# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :event do
    start_time "2013-08-08 15:15:30"
    duration 1
    venue nil
  end
end
