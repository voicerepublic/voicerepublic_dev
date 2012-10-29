# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :notification_basis, :class => 'Notification::Base' do
    
    factory :notification_incoming_call, :class => 'Notification::IncomingCall' do
      type 'Notification::IncomingCall'
      video_session_id 1
      user_id 23
      other_id 'safd34h43l24'
    end
    
    factory :notification_call_accepted, :class => 'Notification::CallAccepted' do
      type 'Notification::CallAccepted'
      url 'http://www.a.kluuu.com'
      video_session_id 1
      other_id 43
      user_id 'safd34h43l24'
    end
    
    factory :notification_call_rejected, :class => 'Notification::CallRejected' do
      type 'Notification::CallRejected'
      video_session_id 1
      other_id 43
      user_id 'safd34h43l24'
    end
    
    factory :notification_new_follower, :class => 'Notification::NewFollower' do
      type 'Notification::NewFollower'
      content 'you have a new follower'
      user_id 23
      other_id 43
    end
    
    factory :notification_new_message, :class => 'Notification::NewMessage' do
      type 'Notification::NewMessage'
      user_id 23
      content "you have a new message"
      other_id 43  
      url "/path/to/conversation"
    end
    
    factory :notification_new_kluuu, :class => 'Notification::NewKluuu' do
      type 'Notification::NewKluuu'
      user_id 23
      klu_id 6
      content "somebody created a new kluuu"
      other_id 43 
    end
    
    
    factory :notification_new_comment, :class => 'Notification::NewComment' do
      type 'Notification::NewComment'
      content { Faker::Lorem.paragraph }
      user_id 23
      other_id 43
      url "/path/to/commentable"
    end
    
    factory :notification_follower_action, :class => 'Notification::FollowerAction' do
      type 'Notification::FollowerAction'
      content 'one of your friend took some action'
      user_id 23
      other_id 43
      klu_id 4
    end
    
    factory :notification_new_rating, :class => 'Notification::NewRating' do
      type 'Notification::NewRating'
      content 'one of your kluuus got rated with some descriptive words'
      user_id 23
      other_id 43
      klu_id 4
    end
    
    factory :notification_new_bookmark, :class => 'Notification::NewBookmark' do
      type 'Notification::NewBookmark'
      content 'one of your kluuus got bookmarked'
      user_id 23
      other_id 43
      klu_id 4
    end
    
    factory :notification_new_status, :class => 'Notification::NewStatus' do
      association :other, factory: :user
      user
      content { Faker::Lorem.paragraph }
    end
    
  end
  
end
