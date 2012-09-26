require 'spec_helper'

describe VideoSession do
  it "has valid first factory" do
    FactoryGirl.create(:video_session).should be_valid
  end
  it "is invalid without an klu_id" do
    FactoryGirl.build(:video_session, klu_id: nil).should_not be_valid
  end
  it "is valid with participants" do
    v = FactoryGirl.create(:video_session_with_participants)
    v.participants.count.should == 2
  end
   it "is valid with klu" do
    v = FactoryGirl.create(:video_session)
    v.kluuu.should be_valid
  end
end
