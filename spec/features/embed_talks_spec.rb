require 'spec_helper'

# it renders specs
describe 'EmbedTalkController' do
  it 'it renders show on GET /embed_talk/:id' do # show
    @talk = FactoryGirl.create(:talk)
    visit embed_talk_path(id: @talk)
    page.should have_selector('.embed_talk-show')
  end
end

