require 'rails_helper'

describe Ability do

  let(:owner) { FactoryGirl.create(:user) }
  let(:other) { FactoryGirl.create(:user) }
  let(:guest) { FactoryGirl.create(:user, guest: true) }

  describe User do
    it "allows to manage user by itself" do
      expect(Ability.new(owner).can?(:manage, owner)).to be_truthy
    end
    it "denies to manage user by other" do
      expect(Ability.new(other).can?(:manage, owner)).to be_falsey
    end
    it "denies to manage user for guests" do
      expect(Ability.new(guest).can?(:manage, guest)).to be_falsey
    end
  end

  describe Venue do
    let(:venue) { FactoryGirl.create(:venue, user: owner) }
    it "allows to manage venues by owner" do
      expect(Ability.new(owner).can?(:manage, venue)).to be_truthy
    end
    it "denies to manage venues by other" do
      expect(Ability.new(other).can?(:manage, venue)).to be_falsey
    end
    it "allows to create venues as registered user (nonguest)" do
      expect(Ability.new(owner).can?(:create, Venue)).to be_truthy
    end
    it "denies to create venues as guest" do
      expect(Ability.new(guest).can?(:create, Venue)).to be_falsey
    end
  end

  describe Comment do
    let(:comment) { FactoryGirl.create(:comment, user: owner) }
    it "allows to manage comments by owner" do
      expect(Ability.new(owner).can?(:manage, comment)).to be_truthy
    end
    it "denies to manage comments by other" do
      expect(Ability.new(other).can?(:manage, comment)).to be_falsey
    end
    it "denies to create comments as guest" do
      expect(Ability.new(guest).can?(:create, Comment.new)).to be_falsey
    end
  end

end
