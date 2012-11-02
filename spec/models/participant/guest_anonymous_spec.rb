require 'spec_helper'

describe Participant::GuestAnonymous do
  it "has a valid factory" do
    FactoryGirl.create(:guest_participant_anonymous).should be_valid
  end
  it "is invalid without an type" do
    FactoryGirl.build(:guest_participant_anonymous, type: nil).should_not be_valid
  end
  it "is invalid without video_session_id" do
    FactoryGirl.build(:guest_participant_anonymous, video_session_id: nil).should_not be_valid
  end
  it "is invalid without video_session_role" do
    FactoryGirl.build(:guest_participant_anonymous, video_session_role: nil).should_not be_valid
  end
  it "is invalid without user_cookie_session_id" do
    FactoryGirl.build(:guest_participant_anonymous, user_cookie_session_id: nil).should_not be_valid
  end
end
