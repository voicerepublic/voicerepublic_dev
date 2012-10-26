require 'spec_helper'

describe Notification::NewRating do
  it "has a valid factory do" do
    FactoryGirl.create(:notification_new_rating).should be_valid
  end
  
  it "is created when my kluuu or session gets rated" do
    rating = FactoryGirl.create(:rating)  
    rating.rateable.user.notifications.alerts.first.should be_a_kind_of(Notification::NewRating)
  end
  
  it "points to a kluuu which was rated" do
    rating = FactoryGirl.create(:rating)  
    rating.rateable.user.notifications.alerts.first.klu.should be_a_kind_of(Klu)
  end

end