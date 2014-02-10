require 'spec_helper'

describe "Talks" do
  describe "GET /talks" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      @venue = FactoryGirl.create(:venue)
      get venue_talks_path(:venue_id => @venue.id)
      response.status.should be(200)
    end
  end
end
