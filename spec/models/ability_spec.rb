require 'rails_helper'
require "cancan/matchers"

describe Ability do

  describe 'as anon' do
    let(:anon) { Ability.new }

    it 'set for comments' do
      expect(anon).not_to be_able_to(:create, Comment)
    end
    it 'set for comments of others' do
      expect(anon).to be_able_to(:read, FactoryGirl.create(:comment))
    end
    it 'set for messages' do
      expect(anon).not_to be_able_to(:create, Message)
    end
    it 'set for messages of others' do
      expect(anon).to be_able_to(:read, FactoryGirl.create(:message))
    end
    it 'set for participations' do
      expect(anon).not_to be_able_to(:create, Participation)
    end
    it 'set for participations of others' do
      expect(anon).to be_able_to(:read, FactoryGirl.create(:participation))
    end
    it 'set for purchases' do
      expect(anon).not_to be_able_to(:create, Purchase)
    end
    it 'set for purchases of others' do
      expect(anon).not_to be_able_to(:read, FactoryGirl.create(:purchase))
    end
    it 'set for reminders' do
      expect(anon).not_to be_able_to(:create, Reminder)
    end
    it 'set for reminders of others' do
      expect(anon).to be_able_to(:read, FactoryGirl.create(:reminder))
    end
    it 'set for talks' do
      expect(anon).not_to be_able_to(:create, Talk)
    end
    it 'set for talks of others' do
      expect(anon).to be_able_to(:read, FactoryGirl.create(:talk))
    end
    it 'set for venues' do
      expect(anon).not_to be_able_to(:create, Venue)
    end
    it 'set for venues of others' do
      expect(anon).to be_able_to(:read, FactoryGirl.create(:venue))
    end
  end

  describe 'as registered users' do
    let(:owner) { FactoryGirl.create(:user) }
    let(:other) { FactoryGirl.create(:user) }
    let(:owner_ability) { Ability.new(owner) }
    let(:other_ability) { Ability.new(other) }

    describe User do
      it "allows to manage user by itself" do
        expect(owner_ability).to be_able_to(:manage, owner)
      end
      it "denies to manage user by other" do
        expect(other_ability).not_to be_able_to(:manage, owner)
      end
    end

    describe Venue do
      let(:venue) { FactoryGirl.create(:venue, user: owner) }
      it "allows to manage venues by owner" do
        expect(owner_ability).to be_able_to(:manage, venue)
      end
      it "denies to manage venues by other" do
        expect(other_ability).not_to be_able_to(:manage, venue)
      end
      it "allows to create venues as registered user" do
        expect(owner_ability).to be_able_to(:create, Venue)
      end
    end

    describe Comment do
      let(:comment) { FactoryGirl.create(:comment, user: owner) }
      it "allows to manage comments by owner" do
        expect(owner_ability).to be_able_to(:manage, comment)
      end
      it "denies to manage comments by other" do
        expect(other_ability).not_to be_able_to(:manage, comment)
      end
    end

    describe Reminder do
      let(:reminder) { FactoryGirl.create(:reminder, user: owner) }
      it "allows managing one's reminders" do
        expect(owner_ability).to be_able_to(:manage, reminder)
      end
      it "denies managing the reminders of others" do
        expect(other_ability).not_to be_able_to(:manage, reminder)
      end
    end

    describe Talk do
      let(:venue) { FactoryGirl.create(:venue, user: owner) }
      let(:talk) { FactoryGirl.create(:talk, venue: venue) }
      it "allows to manage one's own talks" do
        expect(owner_ability).to be_able_to(:manage, talk)
      end
      it "denies to manage other's talks" do
        expect(other_ability).not_to be_able_to(:manage, talk)
      end
      it "allows to create talk if user has at least one credit" do
        expect(owner.reload.credits).to be > 0
        expect(owner_ability).to be_able_to(:create, Talk)
      end
      it "denies to create talk if user has no credits" do
        owner.update_attribute :credits, 0
        expect(owner.credits).to eq(0)
        expect(owner_ability).not_to be_able_to(:create, Talk)
      end
    end

    describe Purchase do
      let(:purchase) { FactoryGirl.create(:purchase, owner: owner) }
      it "allows to create a purchase for registered users" do
        expect(owner_ability).to be_able_to(:create, Purchase)
      end
      it "allows to show one's own purchases" do
        expect(owner_ability).to be_able_to(:show, purchase)
      end
    end

    describe Message do
      it 'allows registered users to create messages' do
        expect(owner_ability).to be_able_to(:create, Message)
      end
    end

    describe Participation do
      it 'allows registered users to create a participation' do
        expect(owner_ability).to be_able_to(:create, Participation)
      end
      it "denies to manage other's participations" do
        participation = FactoryGirl.create(:participation, user: owner)
        expect(other_ability).not_to be_able_to(:manage, participation)
      end
    end
  end

end
