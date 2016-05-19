require 'rails_helper'

RSpec.describe Speaker, type: :model do
  it 'validates presence of fullname' do
    expect(FactoryGirl.build(:speaker, fullname: nil)).to_not be_valid
  end

  it 'does not validate presence of profession' do
    expect(FactoryGirl.build(:speaker, profession: nil)).to_not be_valid
  end
end
