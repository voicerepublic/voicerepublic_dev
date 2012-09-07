# Read about factories at https://github.com/thoughtbot/factory_girl

include ActionDispatch::TestProcess

FactoryGirl.define do
  
  factory :profile_setting do
    timezone { ActiveSupport::TimeZone.all[rand(ActiveSupport::TimeZone.all.length)].name }
    language_1 "DE"
    language_2 "EN"
    language_3 "FR"
    user
    factory :profile_setting_with_portrait do
      portrait { fixture_file_upload( File.join(Rails.root,'app','assets', 'images', 'rails.png')) }
    end
  end
end
