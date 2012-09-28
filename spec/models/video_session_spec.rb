require 'spec_helper'

describe VideoSession do
  it "has valid first factory" do
    FactoryGirl.create(:video_session).should be_valid
  end
  it "is invalid without a klu_id" do
    FactoryGirl.build(:video_session, klu_id: nil).should_not be_valid
  end
  it "is valid with a klu_id" do
    klu = FactoryGirl.create(:published_kluuu)  
    FactoryGirl.build(:video_session, klu_id: klu.id).should be_valid
  end
  it "is valid with a klu_id" do
    params = FactoryGirl.attributes_for(:video_session)
    v = VideoSession.create(params)
    v.should_not be nil
  end
  it "is valid with participants" do
    v = FactoryGirl.create(:video_session_with_participants)
    v.participants.count.should == 2
  end
  it "is valid with kluuu" do
    v = FactoryGirl.create(:video_session, klu_id: FactoryGirl.create(:kluuu).id)
    v.klu.should be_valid
  end
  it "is valid with no_kluuu" do
    v = FactoryGirl.create(:video_session, klu_id: FactoryGirl.create(:no_kluuu).id)
    v.klu.should be_valid
  end
end
