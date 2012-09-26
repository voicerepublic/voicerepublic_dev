require 'spec_helper'

describe VideoSession do
  it "has valid first factory" do
    FactoryGirl.create(:video_session_with_participants).should be_valid
  end
  it "has valid second factory" do
    FactoryGirl.create(:video_session_with_anonymous_participant).should be_valid
  end
  it "is invalid without an offer_id" do
    FactoryGirl.build(:video_session_with_participants, offer_id: nil).should_not be_valid
  end
  it "is invalid without two participants" do
    FactoryGirl.build(:video_session).should_not be_valid
  end
end
