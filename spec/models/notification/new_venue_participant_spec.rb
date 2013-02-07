require 'spec_helper'
require 'pp'

describe Notification::NewVenueParticipant do
  it "has a valid factory" do
    FactoryGirl.create(:notification_new_venue_participant).should be_valid
  end
  
  it "is created for initiator of a venue if a klu joins this venue" do
    #notification = FactoryGirl.create(:notification_new_venue_participant)
    venue_klu = FactoryGirl.create(:venue_klu)
    venue_klu.venue.host_kluuu.user.notifications.alerts.count.should eq(1)
    venue_klu.venue.host_kluuu.user.notifications.alerts.first.should be_a(Notification::NewVenueParticipant)
  end
  
  it "is created for participants of a venue if another klu joins this venue" do
    venue = FactoryGirl.create(:venue)
    first = FactoryGirl.create(:venue_klu, :venue => venue)
    guests = venue.guests
    second = FactoryGirl.create(:venue_klu, :venue => venue)
    guests.first.notifications.alerts.should_not be_empty
    guests.first.notifications.alerts.count.should eq(1)
    guests.first.notifications.alerts.first.should be_a(Notification::NewVenueParticipant)
  end
end