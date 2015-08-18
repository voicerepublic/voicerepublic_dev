require 'rails_helper'

describe Series do

  it "is invalid without title" do
    expect(FactoryGirl.build(:series, :title => nil)).not_to be_valid
  end

  describe 'penalty' do

    it 'has a default penalty of 1' do
      series = FactoryGirl.create(:series)
      expect(series.penalty).to eq(1)
    end

    it 'inherits its penalty from its user' do
      user = FactoryGirl.create(:user)
      user.penalty = 0.5
      user.save!
      series = FactoryGirl.create(:series, user: user)
      expect(series.penalty).to eq(0.5)
    end

    it 'set penalty with set_penalty' do
      series = FactoryGirl.create(:series)
      series.set_penalty!(0.5)
      expect(series.penalty).to eq(0.5)
    end

    it 'bequeaths its penalty to newly created talks' do
      series = FactoryGirl.create(:series)
      series.set_penalty!(0.5)
      talk = FactoryGirl.create(:talk, series: series)
      expect(talk.penalty).to eq(0.5)
    end

  end

end
