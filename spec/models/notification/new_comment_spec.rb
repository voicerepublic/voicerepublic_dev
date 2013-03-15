require 'spec_helper'

describe Notification::NewComment do
  it "has a valid factory do" do
    FactoryGirl.create(:notification_new_comment).should be_valid
  end
  
  it "is created when my status_messages get a comment"  do
    status_update = FactoryGirl.create(:status_update)
    status_update.comments << FactoryGirl.create(:comment, :commentable => status_update)
    status_update.user.notifications.alerts.should_not be_empty
    status_update.user.notifications.alerts.first.should be_a_kind_of(Notification::NewComment)
  end

  it "is created when my kluuu gets commented" do
    klu = FactoryGirl.create(:published_kluuu)
    comment = FactoryGirl.create(:comment, :commentable => klu)
    klu.user.notifications.alerts.should_not be_empty
    klu.user.notifications.alerts.first.should be_a_kind_of(Notification::NewComment)
  end

  it "is created for bookmarker of my commented kluuu" do
    klu = FactoryGirl.create(:published_kluuu)
    FactoryGirl.create_list(:kluuu_bookmark, 3, :klu => klu)
  end

  it "is created when my venue gets commented - for participants of this venue" do
    venue = FactoryGirl.create(:venue)
    venue.klus << FactoryGirl.create_list(:published_no_kluuu, 3)
    venue.save
    c = FactoryGirl.create(:comment, :commentable => venue)
    venue.klus.each do |p|
      p.user.notifications.alerts.should_not be_empty
      p.user.notifications.alerts.first.should be_a_kind_of(Notification::NewComment)
    end
  end
  
  it "has the comment-text as content" do
    status_update = FactoryGirl.create(:status_update)
    status_update.comments << FactoryGirl.create(:comment, :commentable => status_update)
    status_update.user.notifications.alerts.first.content.should_not be_empty
  end
  
  it "is invalid without content" do
    FactoryGirl.build(:notification_new_comment, :content => nil).should_not be_valid
   
  end
  
  it "is invalid without url" do
    FactoryGirl.build(:notification_new_comment, :url => nil).should_not be_valid
  end

end
