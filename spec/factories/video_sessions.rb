# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :video_session do
    association :klu, factory: :kluuu
    #klu
    end_timestamp "2012-09-25 15:46:18"
    begin_timestamp "2012-09-25 15:46:18"
    video_system_session_id "MyString"
    calling_user_id 2345
    calling_user_type 'registered'
  end
  
  factory :kluuu_video_session, class: VideoSession do
    association :klu, factory: :kluuu
    #klu {FactoryGirl.create(:kluuu)}
    end_timestamp "2012-09-25 15:46:18"
    begin_timestamp "2012-09-25 15:46:18"
    video_system_session_id "MyString"
    calling_user_id 2345
    calling_user_type 'registered'
  end
  factory :no_kluuu_video_session, class: VideoSession do
    association :klu, factory: :no_kluuu
    #klu {FactoryGirl.create(:no_kluuu)}
    end_timestamp "2012-09-25 15:46:18"
    begin_timestamp "2012-09-25 15:46:18"
    video_system_session_id "MyString"
    calling_user_id 2345
    calling_user_type 'registered'
  end
end
