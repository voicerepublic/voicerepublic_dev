require 'spec_helper'

describe Notification::NewRating do
  it "has a valid factory do" do
    FactoryGirl.create(:notification_new_rating).should be_valid
  end
  
  it "is created when my kluuu or session gets rated"
  it "points to a kluuu which was rated"

end