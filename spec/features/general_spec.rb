require 'spec_helper'

feature "General feature specs" do

  describe "Block various spider bots" do
    # This is done in app/middlewares/blocker.rb
    it 'blocks EasouSpider' do
      user_agent = "Mozilla 5.0 (EasouSpider)"
      page.driver.browser.header('User-Agent', user_agent)
      visit root_path
      expect(page.status_code).to eq(704)
    end
  end

  # user agents taken from: http://www.useragentstring.com/
  describe "Browser detection" do
    describe "supported browsers" do
      scenario "ie10" do
        user_agent = "Mozilla/5.0 (compatible; MSIE 10.0; Windows NT 6.1; Trident/6.0)"
        supported_browser_scenario(user_agent)
      end
      scenario "chrome 33" do
        user_agent = "Mozilla/5.0 (Windows NT 6.2; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/32.0.1667.0 Safari/537.36"
        supported_browser_scenario(user_agent)
      end
      scenario "safari 7" do
        user_agent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9) AppleWebKit/537.71 (KHTML, like Gecko) Version/7.0 Safari/537.71"
        supported_browser_scenario(user_agent)
      end
      scenario "firefox 25" do
        user_agent = "Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:25.0) Gecko/20100101 Firefox/25.0"
        supported_browser_scenario(user_agent)
      end
    end

    describe "unsupported browsers" do
      scenario "ie9" do
        user_agent = "Mozilla/5.0 (Windows; U; MSIE 9.0; WIndows NT 9.0; en-US))"
        unsupported_browser_scenario(user_agent)
      end
      scenario "chrome 15" do
        user_agent = "Mozilla/5.0 (X11; FreeBSD i386) AppleWebKit/535.2 (KHTML, like Gecko) Chrome/15.0.874.121 Safari/535.2"
        unsupported_browser_scenario(user_agent)
      end
      scenario "safari 5" do
        user_agent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_6_8) AppleWebKit/537.13+ (KHTML, like Gecko) Version/5.1.7 Safari/534.57.2"
        unsupported_browser_scenario(user_agent)
      end
      scenario "firefox 20" do
        user_agent = "Mozilla/5.0 (Windows NT 6.2; Win64; x64;) Gecko/20100101 Firefox/20.0"
        unsupported_browser_scenario(user_agent)
      end
    end
  end


  private

  def supported_browser_scenario(user_agent)
    page.driver.browser.header('User-Agent', user_agent)
    visit root_path
    expect(current_path).to eq(root_path)
  end

  def unsupported_browser_scenario(user_agent)
    page.driver.browser.header('User-Agent', user_agent)
    visit root_path
    expect(current_path).not_to eq(root_path)
    expect(page).to have_content("You are using an outdated browser")
  end

end
