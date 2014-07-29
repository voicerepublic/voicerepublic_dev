require 'spec_helper'

describe Reminder do
  
  it 'is invalid without a user' do
    expect(FactoryGirl.build(:reminder, user: nil)).to_not be_valid
  end

end
