require 'spec_helper'

describe Reminder do
  
  it 'is invalid without a user' do
    expect(FactoryGirl.build(user: nil)).to_not be_valid
  end

end
