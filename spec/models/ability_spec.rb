require 'rails_helper'

describe Ability do

  let(:owner) { FactoryGirl.create(:user) }
  let(:other) { FactoryGirl.create(:user) }

  describe User do
    it "allows to manage user by itself" do
      expect(Ability.new(owner).can?(:manage, owner)).to be_truthy
    end
    it "denies to manage user by other" do
      expect(Ability.new(other).can?(:manage, owner)).to be_falsey
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
    it "allows to create venues as registered user" do
      expect(Ability.new(owner).can?(:create, Venue)).to be_truthy
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
  end

end
