# encoding: utf-8
require 'rails_helper'

describe User do

  it "has a valid factory" do
    expect(FactoryGirl.create(:user)).to be_valid
  end
  it "is invalid without an email" do
    expect(FactoryGirl.build(:user, email: nil)).not_to be_valid
  end
  it "is invalid without firstname" do
    expect(FactoryGirl.build(:user, firstname: nil)).not_to be_valid
  end
  it "is invalid without lastname" do
    expect(FactoryGirl.build(:user, lastname: nil)).not_to be_valid
  end

  it 'should be confirmable' do
    user = FactoryGirl.create(:user, :unconfirmed)
    expect(user).to_not be_confirmed
    user.confirm!
    expect(user).to be_confirmed
  end

  describe 'determines its role to a given talk' do
    let(:user) { FactoryGirl.create(:user) }
    it 'detects being a host' do
      venue = FactoryGirl.create(:venue, user: user)
      talk = FactoryGirl.create(:talk, venue: venue)
      expect(user.role_for(talk)).to be(:host)
    end
    it 'detects being a guest' do
      talk = FactoryGirl.create(:talk)
      FactoryGirl.create(:appearance, user: user, talk: talk)
      expect(user.role_for(talk)).to be(:guest)
    end
    it 'detects being a participant' do
      talk = FactoryGirl.create(:talk)
      FactoryGirl.create(:participation, user: user, venue: talk.venue)
      expect(user.role_for(talk)).to be(:participant)
    end
    it 'shows all logged in users to be participant' do
      # TODO
      # This is due to the fact that we used to have explicit participations on
      # venues through talks. This has been removed, but it is not yet decided
      # on how to continue. For the time being, all logged in users are
      # participants.
      talk = FactoryGirl.create(:talk)
      expect(user.role_for(talk)).to be(:participant)
    end
  end

  describe 'search' do
    it 'has a scope' do
      user0 = FactoryGirl.create(:user, firstname: 'MrBruce')
      user1 = FactoryGirl.create(:user, lastname: 'MrBruce')
      user2 = FactoryGirl.create(:user, firstname: 'Mr', lastname: 'Bruce')
      results = User.search('MrBruce')
      expect(results).to include(user0)
      expect(results).to include(user1)
      expect(results).not_to include(user2)
    end

    it 'ignores accents' do
      # unaccent works different in postgres 9.1.12(server) and 9.1.13(development)
      skip 'omit on ci' if ENV['CI']

      user = FactoryGirl.create(:user, firstname: 'MrBrùce')

      # searching for a user with accent works without writing it
      results = User.search('MrBruce')
      expect(results).to include(user)

      # searching for a user with wrong accents works
      results = User.search('MrBrucè')
      expect(results).to include(user)
    end
  end

  describe 'destroy dependers' do
    it 'destroys venues' do
      user = FactoryGirl.create(:user)
      user.venues = FactoryGirl.create_list(:venue, 3)
      user.save

      user.destroy
      user.venues.each do |venue|
        expect(venue).to be_destroyed
      end
    end

    it 'destroys the default venue' do
      user = FactoryGirl.create(:user)
      default_venue = user.default_venue
      user.destroy
      expect(default_venue).to be_destroyed
    end
  end

  describe 'default venue' do
    it 'creates' do
      user = FactoryGirl.create(:user)
      expect(user.default_venue).not_to be_nil
    end

    it 'does not create for guests' do
      user = FactoryGirl.create(:user, guest: true)
      expect(user.default_venue).to be_nil
    end
  end

  describe 'penalty' do

    it 'has a default penalty of 1' do
      user = FactoryGirl.create(:user)
      expect(user.penalty).to eq(1)
    end

    it 'set penalty with set_penalty' do
      user = FactoryGirl.create(:user)
      user.set_penalty!(0.5)
      expect(user.penalty).to eq(0.5)
    end

    it 'bequeaths its penalty to newly created venues' do
      user = FactoryGirl.create(:user)
      user.set_penalty!(0.5)
      venue = FactoryGirl.create(:venue, user: user)
      expect(venue.penalty).to eq(0.5)
    end

    it 'set penalty deeply with set_penalty' do
      user = FactoryGirl.create(:user)
      venue = FactoryGirl.create(:venue, user: user)
      talk = FactoryGirl.create(:talk, :archived, venue: venue)

      # pick up the extra venue
      user.reload

      user.set_penalty!(0.5)

      # pick up changed penalties
      venue.reload
      talk.reload

      expect(user.penalty).to eq(0.5)
      expect(venue.penalty).to eq(0.5)
      expect(talk.penalty).to eq(0.5)
    end

  end

  describe WelcomeTransaction do

    it 'shows the users some credit' do
      user = FactoryGirl.create(:user)
      expect(user.welcome_transaction).to be_closed
      expect(user.reload.credits).to eq(WelcomeTransaction::QUANTITY)
    end

    it 'does not show guests credit' do
      user = FactoryGirl.create(:user, guest: true)
      expect(user.credits).to eq(0)
    end

  end

end
