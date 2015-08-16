require 'rails_helper'

describe Message do

  it 'validates presence of talk' do
    expect(FactoryGirl.build(:message, talk: nil)).to_not be_valid
  end

end
