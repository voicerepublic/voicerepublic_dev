require 'rails_helper'

feature "General feature specs" do

  describe "Block various spider bots" do
    # This is done in app/middlewares/enforce_robots_txt.rb
    it 'blocks EasouSpider' do
      user_agent = "Mozilla 5.0 (EasouSpider)"
      page.driver.browser.header('User-Agent', user_agent)
      visit root_path
      expect(page.status_code).to eq(704)
    end
  end

end
