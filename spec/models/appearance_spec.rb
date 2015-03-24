require 'rails_helper'

describe Appearance do

  it 'validates presence of user' do
    expect(FactoryGirl.build(:appearance, user: nil)).to_not be_valid
  end

  it 'validates presence of talk' do
    expect(FactoryGirl.build(:appearance, talk: nil)).to_not be_valid
  end

end
