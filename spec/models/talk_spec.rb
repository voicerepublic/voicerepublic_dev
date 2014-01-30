require 'spec_helper'

describe Talk do

  describe 'built' do
    before do
      @talk = FactoryGirl.build(:talk)
    end
    it 'has a valid factory' do
      expect(@talk).to be_valid
    end
    it 'validates presence of venue' do
      @talk.venue = nil
      expect(@talk).to_not be_valid
    end
    it 'validates presence of title' do
      @talk.title = nil
      expect(@talk).to_not be_valid
    end
    it 'validates presence of starts_at' do
      @talk.starts_at = nil
      expect(@talk).to_not be_valid
    end
    it 'provides a method starts_in' do
      expect(@talk.starts_in).to be > 0
    end
  end

  describe 'built relying on callbacks' do
    it 'sets ends_at based on starts_at and duration' do
      talk = FactoryGirl.build(:talk, duration: 45)
      talk.valid? # triggers before_validation callbacks
      expect(talk.ends_at).to eq(talk.starts_at + 45.minutes)
    end
  end

  describe 'on class level' do
    it 'provides a scope upcoming' do
      expected, unexpected = [], []
      expected << FactoryGirl.create(:talk, starts_at: 1.day.from_now)
      expected << FactoryGirl.create(:talk, starts_at: 1.hour.from_now)
      expected << FactoryGirl.create(:talk, starts_at: 1.minute.from_now)
      expected << FactoryGirl.create(:talk, starts_at: 1.minute.ago)
      unexpected << FactoryGirl.create(:talk, starts_at: 1.day.ago)
      expect(Talk.upcoming).to eq(expected)
    end
  end

  describe 'created' do
    before do
      @talk = FactoryGirl.create(:talk)
    end
    it 'computes starts_in for use in prelive' do
      Timecop.freeze do
        expect(@talk.starts_in).to eq((@talk.starts_at - Time.now).to_i)
      end
    end
  end

  describe 'customized' do
    it 'computes starts_in for use in prelive' do
      date_str = '2014-03-20 11:11'
      @talk = FactoryGirl.create(:talk, starts_at: date_str)
      expect(@talk.starts_at.strftime('%Y-%m-%d %H:%M')).to eq(date_str)
      Timecop.freeze do
        expect(@talk.starts_in).to eq((@talk.starts_at - Time.now).to_i)
      end
    end
  end

end
