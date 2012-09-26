require 'spec_helper'

describe RegisteredParticipant do
  it "has a valid factory" do
    FactoryGirl.create(:registered_participant).should be_valid
  end
  it "is invalid without an type" do
    FactoryGirl.build(:registered_participant, type: nil).should_not be_valid
  end
  it "is invalid without video_session_id" do
    FactoryGirl.build(:registered_participant, video_session_id: nil).should_not be_valid
  end
  it "is invalid without video_session_role" do
    FactoryGirl.build(:registered_participant, video_session_role: nil).should_not be_valid
  end
  it "is invalid without user_id" do
    FactoryGirl.build(:registered_participant, user_id: nil).should_not be_valid
  end
end
