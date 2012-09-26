# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :video_session do
    kluuu
    end_timestamp "2012-09-25 15:46:18"
    begin_timestamp "2012-09-25 15:46:18"
    video_system_session_id "MyString"
    
    factory :video_session_with_participants do
      after(:create) do |video_session, evaluator|
        FactoryGirl.create_list(:registered_participant, 2, :video_session => video_session)
      end
    end
  end
end
