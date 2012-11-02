require 'spec_helper'

describe Notification::CallRejected do
  it "has a valid registered factory do" do
    FactoryGirl.create(:notification_registered_call_rejected).should be_valid
  end
  it "is invalid without other_id" do
    FactoryGirl.build(:notification_registered_call_rejected, other_id: nil).should_not be_valid
  end
  it "is invalid without video session" do
    FactoryGirl.build(:notification_registered_call_rejected, video_session_id: nil).should_not be_valid
  end
   it "is invalid without user_id" do
    FactoryGirl.build(:notification_registered_call_accepted, user_id: nil).should_not be_valid
  end
  it "has a valid anonymous factory do" do
    FactoryGirl.create(:notification_anonymous_call_rejected).should be_valid
  end
  it "is invalid without other_id" do
    FactoryGirl.build(:notification_anonymous_call_rejected, other_id: nil).should_not be_valid
  end
  it "is invalid without video session" do
    FactoryGirl.build(:notification_anonymous_call_rejected, video_session_id: nil).should_not be_valid
  end
   it "is invalid without anon_id" do
    FactoryGirl.build(:notification_anonymous_call_accepted, anon_id: nil).should_not be_valid
  end
end