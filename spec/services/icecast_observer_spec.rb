require 'rails_helper'

describe IcecastObserver do

  before do
    @observer = IcecastObserver.new
  end

  it 'should start out empty' do
    expect(@observer.servers).to be_an(Array)
    expect(@observer.servers).to be_empty
  end

  it 'should populate with servers' do
    @observer.handler(nil, nil, '{"server":"127.0.0.1"}')
    expect(@observer.servers).not_to be_empty
    expect(@observer.servers.first).to eq('127.0.0.1')
  end

end
