require 'spec_helper'

describe "VideoServers" do
  
  before do
      %w(admin user).each { |x| Role.create(:name => x)}
      @user = FactoryGirl.create(:user)
      @user.roles << Role.find_by_name('admin')
      @user.save
      @user.reload
   end
  

  describe "GET /admin/video_servers" do
    it "it shows the videoserver-page if logged in as admin" do
      login_user(@user)
      click_link('Manage VideoServer')
      page.should have_content("Video servers")
    end
  end
end
