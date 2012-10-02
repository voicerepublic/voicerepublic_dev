require 'spec_helper'

describe Participant::Anonymous do
  it "has a valid factory" do
    FactoryGirl.create(:participant_anonymous).should be_valid
  end
  it "is invalid without an type" do
    FactoryGirl.build(:participant_anonymous, type: nil).should_not be_valid
  end
  it "is invalid without video_session_id" do
    FactoryGirl.build(:participant_anonymous, video_session_id: nil).should_not be_valid
  end
  it "is invalid without video_session_role" do
    FactoryGirl.build(:participant_anonymous, video_session_role: nil).should_not be_valid
  end
  it "is invalid without user_cookie_session_id" do
    FactoryGirl.build(:participant_anonymous, user_cookie_session_id: nil).should_not be_valid
  end
  it "is valid with video_session" do
    p = FactoryGirl.create(:participant_anonymous)
    p.video_session.should be_valid 
  end
end
