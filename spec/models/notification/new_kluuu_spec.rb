require 'spec_helper'

describe Notification::NewKluuu do
  it "has a valid factory do" do
    FactoryGirl.create(:notification_new_kluuu).should be_valid
  end
  
  it "is created by a person i follow"
  it "points to a published kluuu"
  it "will be created if a person i follow creates a new kluuu"  
end