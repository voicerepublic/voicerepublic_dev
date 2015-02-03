require 'spec_helper'

describe Venue do

  it "is invalid without title" do
    FactoryGirl.build(:venue, :title => nil).should_not be_valid
  end

  describe 'penalty' do

    it 'has a default penalty of 1' do
      venue = FactoryGirl.create(:venue)
      expect(venue.penalty).to eq(1)
    end

    it 'inherits its penalty from its user' do
      user = FactoryGirl.create(:user)
      user.penalty = 0.5
      user.save!
      venue = FactoryGirl.create(:venue, user: user)
      expect(venue.penalty).to eq(0.5)
    end

    it 'set penalty with set_penalty' do
      venue = FactoryGirl.create(:venue)
      venue.set_penalty!(0.5)
      expect(venue.penalty).to eq(0.5)
    end

    it 'bequeaths its penalty to newly created talks' do
      venue = FactoryGirl.create(:venue)
      venue.set_penalty!(0.5)
      talk = FactoryGirl.create(:talk, venue: venue)
      expect(talk.penalty).to eq(0.5)
    end

  end

end
