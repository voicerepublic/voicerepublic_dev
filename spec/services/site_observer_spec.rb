require 'rails_helper'

describe SiteObserver do

  before do
    @observer = SiteObserver.new
  end

  it 'should start out empty' do
    expect(@observer.sites).to be_an(Array)
    expect(@observer.sites).to be_empty
  end

  it 'should populate with servers' do
    payload = {
      'url' => 'http://127.0.0.1'
    }
    @observer.site_observer(payload)
    expect(@observer.sites).not_to be_empty
    expect(@observer.sites.first).to eq('http://127.0.0.1')
  end

end
