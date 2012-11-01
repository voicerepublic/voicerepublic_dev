require 'spec_helper'


describe "Conversations" do
 
  before do
    @user = FactoryGirl.create(:user)
  end
  
  describe "GET /conversations" do
    it "works! (now write some real specs)" do
      login_user(@user)
      visit user_conversations_path(:user_id => @user)
      page.should have_content("Your Conversations")
    end
  end
end
