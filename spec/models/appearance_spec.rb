require 'rails_helper'

describe Appearance do

  it 'validates presence of speaker' do
    expect(FactoryGirl.build(:appearance, speaker: nil)).to_not be_valid
  end

  it 'validates presence of talk' do
    expect(FactoryGirl.build(:appearance, talk: nil)).to_not be_valid
  end

end
