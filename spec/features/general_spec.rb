require 'spec_helper'

feature "General feature specs" do

  describe "Search validation" do
    background do
      visit root_path
    end
    scenario "it should set an error on empty search input", driver: :chrome, slow: true do
      page.fill_in 'query', with: ''
      find("#query").native.send_keys(:return)
      page.should have_css('.warning')

      page.fill_in 'query', with: 'search key'
      page.should_not have_css('.warning')

      page.fill_in 'query', with: ''
      find(".icon-magnifying-glass").click
      page.should have_css('.warning')
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
    current_path.should == root_path
  end

  def unsupported_browser_scenario(user_agent)
    page.driver.browser.header('User-Agent', user_agent)
    visit root_path
    current_path.should_not == root_path
    page.should have_content("You are using an outdated browser")
  end

end
