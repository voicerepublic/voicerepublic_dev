require 'spec_helper'

describe Participant::Registered do
  it "has a valid factory" do
    FactoryGirl.create(:participant_registered).should be_valid
  end
  it "is invalid without an type" do
    FactoryGirl.build(:participant_registered, type: nil).should_not be_valid
  end
  it "is invalid without video_session_id" do
    FactoryGirl.build(:participant_registered, video_session_id: nil).should_not be_valid
  end
  it "is invalid without video_session_role" do
    FactoryGirl.build(:participant_registered, video_session_role: nil).should_not be_valid
  end
  it "is invalid without user_id" do
    FactoryGirl.build(:participant_registered, user_id: nil).should_not be_valid
  end
  it "is valid with video_session" do
    p = FactoryGirl.create(:participant_registered)
    p.video_session.should be_valid
  end
  it "is valid with user" do
    p = FactoryGirl.create(:participant_registered)
    p.user.should be_valid
  end
end
