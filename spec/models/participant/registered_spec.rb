require 'spec_helper'

describe Participant::Registered do
  it "has a valid guest participant factory" do
    FactoryGirl.create(:guest_participant_registered).should be_valid
  end
  it "has a valid host participant factory" do
    FactoryGirl.create(:host_participant).should be_valid
  end
  it "is invalid without an type" do
    FactoryGirl.build(:guest_participant_registered, type: nil).should_not be_valid
  end
  it "is invalid without video_session_id" do
    FactoryGirl.build(:guest_participant_registered, video_session_id: nil).should_not be_valid
  end
  it "is invalid without video_session_role" do
    FactoryGirl.build(:guest_participant_registered, video_session_role: nil).should_not be_valid
  end
  it "is invalid without user_id" do
    FactoryGirl.build(:guest_participant_registered, user_id: nil).should_not be_valid
  end
  it "is valid with user" do
    p = FactoryGirl.create(:guest_participant_registered)
    p.user.should be_valid
  end
end
