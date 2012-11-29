# Read about factories at https://github.com/thoughtbot/factory_girl
include ActionDispatch::TestProcess

FactoryGirl.define do
  
  factory :account do
    timezone { ActiveSupport::TimeZone.all[rand(ActiveSupport::TimeZone.all.length)].name }
    language_1 "DE"
    language_2 "EN"
    language_3 "FR"
    user
    factory :account_with_portrait do
      portrait { fixture_file_upload( File.join(Rails.root,'app','assets', 'images', 'rails.png')) }
    end
    
    factory :account_with_prefs do
      prefs { {:anonymous_calls => "1", :email_concerning_me => "1", :email_concerning_other => "1", :inform_of_friends => "1", :no_initial_help => "1"} }
    end
  end
end
