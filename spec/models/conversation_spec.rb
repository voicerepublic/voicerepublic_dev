require 'spec_helper'

describe Conversation do
  it "has a valid factory" do
    FactoryGirl.create(:conversation).should be_valid
  end
  
  it "is invalid without user_1" do
    FactoryGirl.build(:conversation, :user_1 => nil).should_not be_valid
  end
  it "is invalid without user_2" do
    FactoryGirl.build(:conversation, :user_2 => nil).should_not be_valid
  end
  it "is destroyed if no more messages"
  it "has many messages"
  
end
