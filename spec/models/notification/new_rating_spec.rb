require 'spec_helper'

describe Notification::NewRating do
  
  # it "is created when my kluuu or session gets rated" do
  #   rating = FactoryGirl.create(:rating)  
  #   rating.rateable.user.notifications.alerts.first.should be_a_kind_of(Notification::NewRating)
  # end
  # 
  # it "points to a kluuu which was rated" do
  #   rating = FactoryGirl.create(:rating)  
  #   rating.rateable.user.notifications.alerts.first.klu.should be_a_kind_of(Klu)
  # end
  
  it "has a rating content" do
    FactoryGirl.create(:notification_new_rating).content.should_not be_empty
  end
  
  it "is invalid without content" do
     FactoryGirl.build(:notification_new_rating, :content => nil).should_not be_valid
  end

end
