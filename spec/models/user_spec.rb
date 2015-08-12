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
      series = FactoryGirl.create(:series, user: user)
      talk = FactoryGirl.create(:talk, series: series)
      expect(user.role_for(talk)).to be(:host)
    end
    it 'detects being a guest' do
      talk = FactoryGirl.create(:talk)
      FactoryGirl.create(:appearance, user: user, talk: talk)
      expect(user.role_for(talk)).to be(:guest)
    end
    it 'detects being a participant' do
      talk = FactoryGirl.create(:talk)
      FactoryGirl.create(:participation, user: user, series: talk.series)
      expect(user.role_for(talk)).to be(:participant)
    end
    it 'shows all logged in users to be participant' do
      # TODO
      # This is due to the fact that we used to have explicit participations on
      # series through talks. This has been removed, but it is not yet decided
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
    it 'destroys series' do
      user = FactoryGirl.create(:user)
      user.series = FactoryGirl.create_list(:series, 3)
      user.save

      user.destroy
      user.series.each do |series|
        expect(series).to be_destroyed
      end
    end

    it 'destroys the default series' do
      user = FactoryGirl.create(:user)
      default_series = user.default_series
      user.destroy
      expect(default_series).to be_destroyed
    end
  end

  describe 'default series' do
    it 'creates' do
      user = FactoryGirl.create(:user)
      expect(user.default_series).not_to be_nil
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

    it 'bequeaths its penalty to newly created series' do
      user = FactoryGirl.create(:user)
      user.set_penalty!(0.5)
      series = FactoryGirl.create(:series, user: user)
      expect(series.penalty).to eq(0.5)
    end

    it 'set penalty deeply with set_penalty' do
      user = FactoryGirl.create(:user)
      series = FactoryGirl.create(:series, user: user)
      talk = FactoryGirl.create(:talk, :archived, series: series)

      # pick up the extra series
      user.reload

      user.set_penalty!(0.5)

      # pick up changed penalties
      series.reload
      talk.reload

      expect(user.penalty).to eq(0.5)
      expect(series.penalty).to eq(0.5)
      expect(talk.penalty).to eq(0.5)
    end

  end

  describe "Payment" do
    describe WelcomeTransaction do
      it 'shows the users some credit' do
        user = FactoryGirl.create(:user)
        expect(user.welcome_transaction).to be_closed
        expect(user.reload.credits).to eq(WelcomeTransaction::QUANTITY)
      end
    end
    describe "Pro User" do
      it 'is a pro user when having purchased in the past' do
        user = FactoryGirl.create(:user)

        FactoryGirl.create(:purchase, owner: user)
        expect(user.is_pro?).to be(true)
      end

      it 'is not a pro user when not having purchased in the past' do
        user = FactoryGirl.create(:user)
        transaction_count = Transaction.where(source_id: user.id,
                                              source_type: "Purchase").count
        expect(transaction_count).to eq(0)
        expect(user.is_pro?).to be(false)
      end
    end
  end

  describe 'Create' do
    it 'should not create a confirmation email' do
      ActionMailer::Base.deliveries.clear
      expect(ActionMailer::Base.deliveries).to be_empty
      FactoryGirl.create :user
      expect(ActionMailer::Base.deliveries.last.to_s)
      .to_not include I18n.t("devise.mailer.confirmation_instructions.subject")
    end
  end

end
