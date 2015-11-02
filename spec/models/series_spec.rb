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

  describe 'Hide Series from Search Engines' do
    it 'is by default not hidden' do
      series = FactoryGirl.create :series
      expect(series.is_hidden).to eq(false)
    end

    it 'set hidden with set_hidden!' do
      series = FactoryGirl.create(:series)
      series.set_hidden!(true)
      expect(series.reload.is_hidden).to eq(true)
    end

    it 'is not in the default scope' do
      user = FactoryGirl.create :user
      2.times { FactoryGirl.create :series, user: user }
      expect(Series.count).to be(3)
      Series.last.set_hidden! true
      expect(Series.count).to be(2)
    end

    it 'bequeaths its hidden nature to newly created series' do
      user = FactoryGirl.create(:user)
      user.set_hidden! true
      series = FactoryGirl.create(:series, user: user)
      expect(series.is_hidden).to eq(true)
    end

    it 'set hidden deeply with set_hidden!' do
      user = FactoryGirl.create(:user)
      series = FactoryGirl.create(:series, user: user)
      talk = FactoryGirl.create(:talk, :archived, series: series)

      # pick up the extra series
      user.reload

      user.set_hidden!(true)

      # pick up changed hidden nature
      series.reload
      talk.reload

      expect(user.is_hidden).to eq(true)
      expect(series.is_hidden).to eq(true)
      expect(talk.is_hidden).to eq(true)
    end

  end

end
