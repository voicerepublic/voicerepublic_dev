require 'spec_helper'

describe VideoSession do
  
  # before do
  #   Klu.stub(:allow_anonymous_calls?).and_return(true)
  # end
  # 
  # it "has valid basic video session factory" do
  #   FactoryGirl.build(:video_session).should be_valid
  # end
  # it "has valid anonymous video session factory" do
  #   FactoryGirl.build(:anonymous_video_session).should be_valid
  # end
  # it "has valid kluuu registered video session factory" do
  #   FactoryGirl.build(:kluuu_registered_video_session).should be_valid
  # end
  # it "has valid kluuu anonymous video session factory" do
  #   FactoryGirl.build(:kluuu_anonymous_video_session).should be_valid
  # end
  # it "has valid no kluuu registered video session factory" do
  #   FactoryGirl.build(:no_kluuu_registered_video_session).should be_valid
  # end
  # it "has valid no kluuu anonymous video session factory" do
  #   FactoryGirl.build(:no_kluuu_anonymous_video_session).should be_valid
  # end
  # it "is invalid without a klu" do
  #   FactoryGirl.build(:registered_video_session, klu_id: nil).should_not be_valid
  # end
  # it "is valid with registered participants" do
  #   v = FactoryGirl.create(:registered_video_session)
  #   v.host_participant.should_not be_nil
  #   v.guest_participant.should_not be_nil
  # end
  # it "is valid with anonymous participant" do
  #   v = FactoryGirl.create(:anonymous_video_session)
  #   v.host_participant.should_not be_nil
  #   v.guest_participant.should_not be_nil
  # end
  # it "is invalid without registered calling_user_id" do
  #   FactoryGirl.build(:registered_video_session, calling_user_id: nil).should_not be_valid
  # end
  # it "is invalid without anonymous calling_user_id" do
  #   FactoryGirl.build(:anonymous_video_session, calling_user_id: nil).should_not be_valid
  # end

end
