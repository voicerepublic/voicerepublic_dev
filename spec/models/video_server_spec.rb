require 'spec_helper'

describe VideoServer do
  it "has a valid factory do" do
    FactoryGirl.create(:video_server).should be_valid
  end
  it "has a valid deactivated server factory do" do
    FactoryGirl.create(:deactivated_video_server).should be_valid
  end
  it "is invalid without salt" do
    FactoryGirl.build(:video_server, salt: nil).should_not be_valid
  end
  it "is invalid without name" do
    FactoryGirl.build(:video_server, name: nil).should_not be_valid
  end
  it "is invalid without url" do
    FactoryGirl.build(:video_server, url: nil).should_not be_valid
  end
  it "is invalid without version" do
    FactoryGirl.build(:video_server, version: nil).should_not be_valid
  end
end
