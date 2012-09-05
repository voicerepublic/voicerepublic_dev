# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :profile_setting do
    timezone { ActiveSupport::TimeZone.all[rand(ActiveSupport::TimeZone.all.length)].name }
    language_1 "DE"
    language_2 "EN"
    language_3 "FR"
    user
  end
end
