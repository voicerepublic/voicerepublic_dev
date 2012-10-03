require 'spec_helper'

describe Notification::NewBookmark do
  it "has a valid factory do" do
    FactoryGirl.create(:notification_new_bookmark).should be_valid
  end
  
  it "is created when my kluuu gets bookmarked"
  it "points to the bookmaring user"

end