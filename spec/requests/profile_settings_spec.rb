require 'spec_helper'

describe "ProfileSettings" do
  describe "GET /profile_settings" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get profile_settings_path
      response.status.should be(200)
    end
  end
end
