require 'rails_helper'

# it renders specs
describe 'Embed::TalkController' do
  # new school
  it 'it renders show on GET /embed/talks/:id' do
    @talk = FactoryGirl.create(:talk)

    visit embed_talk_path(id: @talk)
    expect(page).to have_selector('.embed-show')
  end

  # old school
  it 'it renders show on GET /embed/:id' do
    @talk = FactoryGirl.create(:talk)
    visit embed_url(@talk)
    expect(page).to have_selector('.embed-show')
  end
end
