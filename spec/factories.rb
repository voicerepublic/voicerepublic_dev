# Read about factories at https://github.com/thoughtbot/factory_girl
require 'faker'

include ActionDispatch::TestProcess

FactoryGirl.define do

  # basic models

  factory :event do
    start_time 1.week.ago
    duration   90
    venue
    title      "Spec event title"
  end

  factory :venue do
    tag_list    'some, tags'
    summary     Faker::Lorem.paragraphs(1)
    description Faker::Lorem.paragraphs(2)
    title       Faker::Lorem.sentence
    intro_video "MyString"
    user

    factory :venue_with_events do
      ignore do
        events_count 3
      end
      after(:build) do |venue, evaluator|
        evaluator.events_count.times do |i|
          venue.events << FactoryGirl.create(:event)
        end
      end
    end
  end

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
      prefs { {
          :anonymous_calls => "1",
          :email_concerning_me => "1",
          :email_concerning_other => "1",
          :inform_of_friends => "1",
          :no_initial_help => "1"
        } }
    end
  end

  factory :article do
    venue
    content "MyText"
    user
  end

  factory :user do
    email { Faker::Internet.email }
    firstname { Faker::Name.first_name }
    lastname { Faker::Name.last_name }
    available "online"
    last_request_at {Time.now}
    secret = "mysecret"
    password secret
    password_confirmation secret
    # trait :with_portrait do
    #   association :account, factory: :account_with_portrait
    # end
    factory :admin do
      # TODO: create factory for role and user_role
      # roles [Role.find_by_name('user'), Role.find_by_name('admin')]
    end
    #factory :user_with_portrait, traits: [:with_portrait]
  end

  # bookkeeping models

  factory :balance_account, :class => 'Balance::Account' do
    currency "EUR"
    balance_cents 25000
    revenue_cents 0
    user
  end

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

  # factory :bookmark do
  #   user
  #
  #   trait :no_kluuu_bookmark do
  #     no_kluuu
  #   end
  #
  #   trait :kluuu_bookmark do
  #     kluuu
  #   end
  #
  #   factory :no_kluuu_bookmark, traits: [:no_kluuu_bookmark]
  #   factory :kluuu_bookmark, :traits => [:kluuu_bookmark]
  # end
  #
  # factory :category do
  #   name { Faker::Lorem.words(1)}
  # end
  #
  # factory :child_category, :class => Category do
  #   _category =
  #   name { Faker::Lorem.words(1)}
  #   parent_id { FactoryGirl.create(:category).id }
  # end

  factory :comment do
    content { Faker::Lorem.paragraph }
    article
    user
  end

  factory :conversation do
    association :user_1, factory: :user
    association :user_2, factory: :user
  end

  factory :follow do
    association :follower, factory: :user
    association :followed, factory: :user
  end

  # factory :klu_image do
  #   description { Faker::Lorem.paragraph }
  #   kluuu
  #   image { fixture_file_upload(File.join(Rails.root,'app','assets', 'images', 'rails.png'))}
  # end
  #
  # factory :klu do
  #   description Faker::Lorem.paragraphs(2).join("\n")
  #   available_at_times "always when online"
  #   association :user, factory: :user
  #   category
  #   currency 'EUR'
  #   charge_cents 0
  #
  #   sequence :title do |t|
  #     "#{Faker::Lorem.sentence} #{t}"
  #   end
  # end
  #
  # factory :kluuu do
  #   description Faker::Lorem.paragraphs(2).join("\n")
  #   available_at_times "always when online"
  #   association :user
  #   category
  #   currency 'EUR'
  #   charge_cents 0
  #   tag_list "foo, bar, baz"
  #
  #   sequence :title do |t|
  #     "#{Faker::Lorem.sentence} #{t}"
  #   end
  #
  #   trait :unpublished_kluuu do
  #     published false
  #   end
  #
  #   trait :published_kluuu do
  #     published true
  #   end
  #
  #   factory :unpublished_kluuu, traits: [:unpublished_kluuu]
  #   factory :published_kluuu, traits: [:published_kluuu]
  #
  #   factory :kluuu_with_image do
  #     after(:create) do |kluuu, evaluator|
  #       FactoryGirl.create(:klu_image, :kluuu => kluuu)
  #     end
  #   end
  #
  #   factory :bookmarked_kluuu do
  #     after(:create) do |kluuu,evaluator|
  #       FactoryGirl.create_list(:kluuu_bookmark, 3, :kluuu => kluuu)
  #     end
  #   end
  #
  # end

  factory :message do
    association :receiver, factory: :user
    association :sender, factory: :user

    conversation_id 1

    content { Faker::Lorem.paragraph }
  end

  # factory :no_kluuu do
  #
  #   #description Faker::Lorem.paragraphs(2).join("\n")
  #   #available_at_times "always when online"
  #
  #   sequence :title do |t|
  #     "#{Faker::Lorem.sentence} #{t}"
  #   end
  #
  #   association :user, factory: :user
  #   category
  #   tag_list "foo, bar, baz"
  #
  #   factory :unpublished_no_kluuu do
  #     published false
  #   end
  #   factory :published_no_kluuu do
  #     published true
  #   end
  # end

  factory :notification_basis, :class => 'Notification::Base' do

    factory :notification_anonymous_incoming_call, :class => 'Notification::IncomingCall' do
      type 'Notification::IncomingCall'
      video_session_id 1
      user
      anon_id 'safd34h43l24'
      #association :klu, factory: :published_kluuu
    end

    factory :notification_anonymous_call_accepted, :class => 'Notification::CallAccepted' do
      type 'Notification::CallAccepted'
      url 'http://www.a.kluuu.com'
      video_session_id 1
      association :other, factory: :user
      anon_id 'safd34h43l24'
      #association :klu, factory: :published_kluuu
    end

    factory :notification_anonymous_call_rejected, :class => 'Notification::CallRejected' do
      type 'Notification::CallRejected'
      video_session_id 1
      association :other, factory: :user
      #association :klu, factory: :published_kluuu
      anon_id 'safd34h43l24'
    end

    factory :notification_registered_incoming_call, :class => 'Notification::IncomingCall' do
      type 'Notification::IncomingCall'
      video_session_id 1
      association :other, factory: :user
      #association :klu, factory: :published_kluuu
      user
    end

    factory :notification_registered_call_accepted, :class => 'Notification::CallAccepted' do
      type 'Notification::CallAccepted'
      url 'http://www.a.kluuu.com'
      video_session_id 1
      association :other, factory: :user
      #association :klu, factory: :published_kluuu
      user
    end

    factory :notification_registered_call_rejected, :class => 'Notification::CallRejected' do
      type 'Notification::CallRejected'
      video_session_id 1
      association :other, factory: :user
      #association :klu, factory: :published_kluuu
      user
    end

    factory :notification_missed_call, :class => 'Notification::MissedCall' do
      type 'Notification::MissedCall'
      video_session_id 1
      association :other, factory: :user
      user
      #association :klu, factory: :published_kluuu
    end

    factory :notification_new_follower, :class => 'Notification::NewFollower' do
      type 'Notification::NewFollower'
      content 'you have a new follower'
      user
      association :other, factory: :user
    end

    factory :notification_new_message, :class => 'Notification::NewMessage' do
      type 'Notification::NewMessage'
      user
      content "you have a new message"
      association :other, factory: :user
      url "/path/to/conversation"
    end

    # factory :notification_new_kluuu, :class => 'Notification::NewKluuu' do
    #   type 'Notification::NewKluuu'
    #   user
    #   association :klu, factory: :published_kluuu
    #   content "somebody created a new kluuu"
    #   association :other, factory: :user
    # end

    factory :notification_new_comment, :class => 'Notification::NewComment' do
      type 'Notification::NewComment'
      content { Faker::Lorem.paragraph }
      user
      association :other, factory: :user
      url "/path/to/commentable"
    end

    factory :notification_follower_action, :class => 'Notification::FollowerAction' do
      type 'Notification::FollowerAction'
      content 'one of your friend took some action'
      user
      association :other, factory: :user
      #association :klu, factory: :published_kluuu
    end

    factory :notification_new_rating, :class => 'Notification::NewRating' do
      type 'Notification::NewRating'
      content 'one of your kluuus got rated with some descriptive words'
      user
      association :other, factory: :user
      #association :klu, factory: :published_kluuu
    end

    # factory :notification_new_bookmark, :class => 'Notification::NewBookmark' do
    #   type 'Notification::NewBookmark'
    #   content 'one of your kluuus got bookmarked'
    #   user
    #   association :other, factory: :user
    #   association :klu, factory: :published_kluuu
    # end

    factory :notification_new_status, :class => 'Notification::NewStatus' do
      association :other, factory: :user
      user
      content { Faker::Lorem.paragraph }
    end

    factory :notification_new_venue, :class => "Notification::NewVenue" do
      association :other, factory: :venue
      user
      content { Faker::Lorem.paragraph }
    end

    factory :notification_new_venue_participant, :class => "Notification::NewVenueParticipant" do
      user
      association :other, factory: :venue
      #association :klu, factory: :published_no_kluuu
      content { Faker::Lorem.paragraph }
    end

    factory :notification_venue_info, :class => "Notification::VenueInfo" do
      user
      association :other, factory: :venue_with_events
    end
  end

  factory :participant_basis, :class => 'Participant::Base' do
    #ignore do
    #  invalid_factory true
    #end

    factory :guest_participant_registered, :class => 'Participant::GuestRegistered' do
      association :user, factory: :user
      type "Participant::GuestRegistered"
      video_session_id 1
      video_session_role "guest"
    end

    factory :host_participant, :class => 'Participant::HostRegistered' do
      association :user, factory: :user
      type "Participant::HostRegistered"
      video_session_id 1
      video_session_role "host"
    end

    factory :guest_participant_anonymous, :class => 'Participant::GuestAnonymous' do
      type "Participant::GuestAnonymous"
      video_session_id 1
      video_session_role "guest"
      user_cookie_session_id "0815participant"
    end

  end

  factory :paypal_payment do
    params "{1=>2}"
    association :check_in_order, factory: :balance_check_in_order
    status "MyString"
    amount { check_in_order ? check_in_order.amount : 10 }
    tact_id "adsfasdfasdfa"
    currency { check_in_order ? check_in_order.currency : "EUR" }
  end

  # factory :rating do
  #   #association :rateable, factory: :published_kluuu
  #   #rateable_type "Klu"
  #   user
  #   content "MyText"
  #   score 3
  # end

  factory :status_update do
    content Faker::Lorem.paragraph
    user
  end

  factory :transfer do
    account_id 1
    video_session_id 1
    duration 1
    transfer_charge_cents 1
    transfer_charge_currency "MyString"
    transfer_gross_cents 1
    transfer_gross_currency "MyString"
    video_session_charge_cents 1
    video_session_charge_currency "MyString"
    exchange_rate "9.99"
    video_session_klu_name "MyString"
  end

  # factory :venue_klu do
  #   association :venue, factory: :venue
  #   association :klu, factory: :published_no_kluuu
  #
  #   factory :venue_no_kluuu do
  #     association :klu, factory: :published_no_kluuu
  #   end
  #
  #   factory :venue_kluuu do
  #     association :klu, factory: :published_kluuu
  #   end
  #
  # end

  factory :video_room do
    sequence(:video_server_id) { |n| n }
    sequence(:video_session_id) { |n| n }
    video_system_room_id { Faker::Lorem.characters(16) }
    guest_password { Faker::Lorem.characters(16) }
    host_password { Faker::Lorem.characters(16) }
    name { Faker::Name.name }
    welcome_msg "Viel Spass"
  end

  # factory :video_room_without_system_id, class: VideoRoom do
  #   sequence(:video_server_id) { |n| n }
  #   sequence(:video_session_id) { |n| n }
  #   guest_password { Faker::Lorem.characters(16) }
  #   host_password { Faker::Lorem.characters(16) }
  #   name { Faker::Name.name }
  #   welcome_msg "Viel Spass"
  # end

  factory :video_server do
    name { Faker::Name.name }
    url { "http://videoserver#{Faker::Lorem.characters(3)}.kluuu.com/bigbluebutton/api" }
    salt { Faker::Lorem.characters(25) }
    activated true
  end

  factory :deactivated_video_server, class: VideoServer do
    name { Faker::Name.name }
    url { "http://videoserver#{Faker::Lorem.characters(3)}.kluuu.com/bigbluebutton/api" }
    salt { Faker::Lorem.characters(25) }
    activated false
  end

  factory :registered_video_session, class: VideoSession::Registered do
    #association :klu, factory: :published_kluuu
    video_system_session_id {Faker::Lorem.characters(25)}
    calling_user_id {FactoryGirl.create(:user).id}
    type 'VideoSession::Registered'
  end

  #for video_room and video_server
  factory :video_session, class: VideoSession::Anonymous do
    #association :klu, factory: :published_kluuu
    video_system_session_id {Faker::Lorem.characters(25)}
    calling_user_id 'pt32742jddddj23'
    type 'VideoSession::Anonymous'
  end

  factory :anonymous_video_session, class: VideoSession::Anonymous do
    #association :klu, factory: :published_kluuu
    video_system_session_id {Faker::Lorem.characters(25)}
    calling_user_id 'pt32742jddddj23'
    type 'VideoSession::Anonymous'
  end

  # factory :kluuu_registered_video_session, class: VideoSession::Registered do
  #   association :klu, factory: :published_kluuu
  #   video_system_session_id {Faker::Lorem.characters(25)}
  #   calling_user_id {FactoryGirl.create(:user).id}
  #   type 'VideoSession::Registered'
  # end
  #
  # factory :kluuu_anonymous_video_session, class: VideoSession::Anonymous do
  #   association :klu, factory: :published_kluuu
  #   video_system_session_id {Faker::Lorem.characters(25)}
  #   calling_user_id 'pt32742jddddj23'
  #   type 'VideoSession::Anonymous'
  # end
  #
  # factory :no_kluuu_registered_video_session, class: VideoSession::Registered do
  #   association :klu, factory: :published_no_kluuu
  #   video_system_session_id {Faker::Lorem.characters(25)}
  #   calling_user_id {FactoryGirl.create(:user).id}
  #   type 'VideoSession::Registered'
  # end
  #
  # factory :no_kluuu_anonymous_video_session, class: VideoSession::Anonymous do
  #   association :klu, factory: :published_no_kluuu
  #   video_system_session_id {Faker::Lorem.characters(25)}
  #   calling_user_id 'pt32742jddddj23'
  #   type 'VideoSession::Anonymous'
  # end

  factory :participation do
    venue nil
    user nil
  end

end
