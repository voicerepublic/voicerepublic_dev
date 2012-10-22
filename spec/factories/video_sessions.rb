# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :registered_video_session, class: VideoSession::Registered do
    klu
    end_timestamp "2012-09-25 15:46:18"
    begin_timestamp "2012-09-25 15:46:18"
    video_system_session_id "MyString"
    calling_user_id {FactoryGirl.create(:user).id}
    type 'VideoSession::Registered'
  end
  factory :anonymous_video_session, class: VideoSession::Anonymous do
    klu
    end_timestamp "2012-09-25 15:46:18"
    begin_timestamp "2012-09-25 15:46:18"
    video_system_session_id "MyString"
    calling_user_id 'pt32742jddddj23'
    type 'VideoSession::Anonymous'
  end
  factory :kluuu_registered_video_session, class: VideoSession::Registered do
    klu {FactoryGirl.create(:kluuu)}
    end_timestamp "2012-09-25 15:46:18"
    begin_timestamp "2012-09-25 15:46:18"
    video_system_session_id "MyString"
    calling_user_id {FactoryGirl.create(:user).id}
    type 'VideoSession::Registered'
  end
  factory :kluuu_anonymous_video_session, class: VideoSession::Anonymous do
    klu {FactoryGirl.create(:kluuu)}
    end_timestamp "2012-09-25 15:46:18"
    begin_timestamp "2012-09-25 15:46:18"
    video_system_session_id "MyString"
    calling_user_id 'pt32742jddddj23'
    type 'VideoSession::Anonymous'
  end
  factory :no_kluuu_registered_video_session, class: VideoSession::Registered do
    klu {FactoryGirl.create(:no_kluuu)}
    end_timestamp "2012-09-25 15:46:18"
    begin_timestamp "2012-09-25 15:46:18"
    video_system_session_id "MyString"
    calling_user_id {FactoryGirl.create(:user).id}
    type 'VideoSession::Registered'
  end
  factory :no_kluuu_anonymous_video_session, class: VideoSession::Anonymous do
    klu {FactoryGirl.create(:no_kluuu)}
    end_timestamp "2012-09-25 15:46:18"
    begin_timestamp "2012-09-25 15:46:18"
    video_system_session_id "MyString"
    calling_user_id 'pt32742jddddj23'
    type 'VideoSession::Anonymous'
  end
end
