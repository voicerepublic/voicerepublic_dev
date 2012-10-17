require 'faker'

FactoryGirl.define do
  factory :video_server do
    name { Faker::Name.name }
    sequence(:url) { |n| "http://videoserver#{n}.kluuu.com/bigbluebutton/api" }
    salt { Faker::Lorem.characters(25) }
    version "0.7"
    activated true
  end
end

FactoryGirl.define do
  factory :deactivated_video_server, class: VideoServer do
    name "MyVideoServer"
    url "http://88.34.42.12/bigbluebutton/api"
    salt { Faker::Lorem.characters(25) }
    version "0.7"
    activated false
  end
end

