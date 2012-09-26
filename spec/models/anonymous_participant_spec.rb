require 'spec_helper'

describe AnonymousParticipant do
  it "has a valid factory" do
    FactoryGirl.create(:anonymous_participant).should be_valid
  end
  it "is invalid without an type" do
    FactoryGirl.build(:anonymous_participant, type: nil).should_not be_valid
  end
  it "is invalid without video_session_id" do
    FactoryGirl.build(:anonymous_participant, video_session_id: nil).should_not be_valid
  end
  it "is invalid without video_session_role" do
    FactoryGirl.build(:anonymous_participant, video_session_role: nil).should_not be_valid
  end
  it "is invalid without user_cookie_session_id" do
    FactoryGirl.build(:anonymous_participant, user_cookie_session_id: nil).should_not be_valid
  end
end
