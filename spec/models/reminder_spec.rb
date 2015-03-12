require 'rails_helper'

describe Reminder do
  
  it 'is invalid without a user' do
    expect(FactoryGirl.build(:reminder, user: nil)).to_not be_valid
  end

  it 'is destroyed with the rememberable' do
    talk = FactoryGirl.create(:talk)
    reminder = FactoryGirl.create(:reminder, rememberable: talk)
    talk.destroy
    expect(Reminder.exists?(id: reminder.id)).to be_falsey
  end
  
end
