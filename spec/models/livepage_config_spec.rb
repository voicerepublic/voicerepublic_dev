require 'rails_helper'

describe LivepageConfig do

  let(:talk) { FactoryGirl.create(:talk) }
  let(:user) { FactoryGirl.create(:user) }
  let(:config) { LivepageConfig.new(talk, user) }

  it 'provides a spec of thre statemachine' do
    expect(config.statemachine).to be_an(Array)
    config.statemachine.each do |transition|
      expect(transition[:name]).to_not be_blank
      expect(transition[:from]).to_not be_blank
      expect(transition[:to]).to_not be_blank
    end
  end

  it 'provides a hash' do
    expect(config.to_hash).to be_a(Hash)
  end

  it 'provides details for the talk' do
    expect(config.to_hash[:talk]).to be_a(Hash)
  end

  it 'provides details for the user' do
    expect(config.to_hash[:user]).to be_a(Hash)
  end

end
