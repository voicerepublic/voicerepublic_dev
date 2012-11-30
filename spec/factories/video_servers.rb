require 'faker'

FactoryGirl.define do
  factory :video_server do
    name { Faker::Name.name }
    url { "http://videoserver#{Faker::Lorem.characters(3)}.kluuu.com/bigbluebutton/api" }
    salt { Faker::Lorem.characters(25) }
    activated true
  end
end

FactoryGirl.define do
  factory :deactivated_video_server, class: VideoServer do
    name { Faker::Name.name }
    url { "http://videoserver#{Faker::Lorem.characters(3)}.kluuu.com/bigbluebutton/api" }
    salt { Faker::Lorem.characters(25) }
    activated false
  end
end

