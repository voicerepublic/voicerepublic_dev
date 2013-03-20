require 'spec_helper'

describe "Venues" do
  
 before do
   @user = FactoryGirl.create(:user)
   @user.roles << Role.find_by_name('venue_host')
   @user.save
   @user.reload
   klu = FactoryGirl.create(:published_kluuu, :user => @user)
   @time = DateTime.now
   @venue = FactoryGirl.create(:venue, :host_kluuu => klu, :start_time => @time)
   login_user(@user)
 end
  
 describe "GET /venues" do
   it "works! (now write some real specs)" do
     visit venues_path
     page.should have_selector(".venue-list")
   end
 end
 
 describe "GET a specific venue page" do
   it "will render the venues page" do
     visit venue_path(:id => @venue)
     page.should have_selector(".venue-show")
   end
   
   it "will render the chat area with a specific field rendering host-info" do
     visit venue_path(:id => @venue)
     @venue.start_time.should eq(@time)
     page.should have_css('div.host-info span.label-important')
   end
   
   it "will have a button for venue-host to broadcast new info" do
     visit venue_path(:id => @venue)
     find_button('broadcast')
   end
 end
end
