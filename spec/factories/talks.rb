# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :talk do
    title "MyString"
    venue
    starts_at 1.hour.from_now.strftime('%Y-%m-%d %H:%M')
    # ends_at   2.hour.from_now
    # ended_at 90.minutes.from_now
    duration 60
    record false
    # recording "MyString"
  end
end
