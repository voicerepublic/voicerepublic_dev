require 'spec_helper'

describe VideoSession do
  it "has valid basic video session factory" do
    FactoryGirl.create(:video_session).should be_valid
  end
  it "has valid kluuu video session factory" do
    FactoryGirl.build(:kluuu_video_session).should be_valid
  end
  it "has valid anonymous video session factory" do
    FactoryGirl.build(:anonymous_video_session).should be_valid
  end
  it "has valid no kluuu video session factory" do
    FactoryGirl.build(:no_kluuu_video_session).should be_valid
  end
  it "is invalid without a klu" do
    FactoryGirl.build(:kluuu_video_session, klu: nil).should_not be_valid
  end
  it "is valid with participants" do
    v = FactoryGirl.create(:video_session)
    v.participants.count.should == 2
  end
  it "is invalid with less than 2 participants" do
    FactoryGirl.build(:kluuu_video_session, calling_user_id: nil).should_not be_valid
  end
end
