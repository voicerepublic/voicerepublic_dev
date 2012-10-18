require 'spec_helper'


describe "Conversations" do
 
  before do
    @user = FactoryGirl.create(:user)
  end
  
  describe "GET /conversations" do
    it "works! (now write some real specs)" do
      
      sign_in_as_a_valid_user
      #@user = FactoryGirl.create(:user) 
      
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get user_conversations_path(:user_id => @user)
      response.status.should be(200)
    end
  end
end
