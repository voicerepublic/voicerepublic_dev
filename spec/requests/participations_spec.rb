require 'spec_helper'

describe "Participations" do
  describe "GET /participations" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get participations_path
      response.status.should be(200)
    end
  end
end
