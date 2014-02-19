require 'spec_helper'

describe "Talks" do

  describe "validation" do

    before do
      @venue = FactoryGirl.create :venue
      @talk = FactoryGirl.create :talk, venue: @venue, tag_list: "test, foo, bar"
    end

    it "does not lose tags on failed validation", js: true, :retry => 3 do
      visit edit_venue_talk_path 'en', @venue, @talk
      fill_in :talk_title, with: ""
      click_on I18n.t 'helpers.submit.submit'
      page.should have_content "Please review the problems below"
      within '#s2id_talk_tag_list.tagList' do
        page.should have_content "test"
        page.should have_content "foo"
        page.should have_content "bar"
      end
    end

  end

end
