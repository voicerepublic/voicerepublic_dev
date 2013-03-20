require 'spec_helper'

describe "Venues" do
 describe "GET /venues" do
   it "works! (now write some real specs)" do
     visit venues_path
     expect(page).to have_selector(".venue-list")
   end
 end
end
