require 'spec_helper'

describe Conversation do
  it "has a valid factory" do
    FactoryGirl.create(:conversation).should be_valid
  end
  
  it "is invalid without user" 
  it "is invalid without partner"
  it "is destroyed if no more messages"
  it "has many messages"
  
end
