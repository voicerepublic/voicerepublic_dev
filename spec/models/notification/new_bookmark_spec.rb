require 'spec_helper'

describe Notification::NewBookmark do
  
  it "has a valid factory do" do
    FactoryGirl.create(:notification_new_bookmark).should be_valid
  end
  
  it "is created when my kluuu gets bookmarked" do
    klu = FactoryGirl.create(:published_kluuu)
    bookmark = FactoryGirl.create(:kluuu_bookmark, :kluuu => klu )
    klu.user.notifications.alerts.should_not be_empty
    klu.user.notifications.alerts.first.klu.should be_a_kind_of(Klu)
  end
  
  it "is created when my no_kluuu gets bookmarked" do
    no_klu = FactoryGirl.create(:published_no_kluuu)
    bookmark = FactoryGirl.create(:no_kluuu_bookmark, :no_kluuu => no_klu )
    no_klu.user.notifications.alerts.should_not be_empty
    no_klu.user.notifications.alerts.first.should be_a_kind_of(Notification::NewBookmark)
    no_klu.user.notifications.alerts.first.klu_id.should eq(no_klu.id)
    no_klu.user.notifications.alerts.first.user.should eq(no_klu.user)
  end
  
  it "points to the bookmarking user" do
    klu = FactoryGirl.create(:published_kluuu)
    bookmark = FactoryGirl.create(:kluuu_bookmark, :kluuu => klu )
    klu.user.notifications.alerts.first.other.should be_a_kind_of(User)
  end

end