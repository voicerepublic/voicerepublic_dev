require 'spec_helper'

describe Ability do

  let(:owner) { FactoryGirl.create(:user) }
  let(:other) { FactoryGirl.create(:user) }
  let(:guest) { FactoryGirl.create(:user, guest: true) }
  
  describe User do
    it "allows to manage user by itself" do
      Ability.new(owner).can?(:manage, owner).should be_true
    end
    it "denies to manage user by other" do
      Ability.new(other).can?(:manage, owner).should be_false
    end
    it "denies to manage user for guests" do
      Ability.new(guest).can?(:manage, guest).should be_false
    end
  end

  describe Venue do
    let(:venue) { FactoryGirl.create(:venue, user: owner) }
    it "allows to manage venues by owner" do
      Ability.new(owner).can?(:manage, venue).should be_true
    end
    it "denies to manage venues by other" do
      Ability.new(other).can?(:manage, venue).should be_false
    end
    it "allows to create venues as registered user (nonguest)" do
      Ability.new(owner).can?(:create, Venue).should be_true
    end
    it "denies to create venues as guest" do
      Ability.new(guest).can?(:create, Venue).should be_false
    end
  end

  describe Comment do
    let(:comment) { FactoryGirl.create(:comment, user: owner) }
    it "allows to manage comments by owner" do
      Ability.new(owner).can?(:manage, comment).should be_true
    end
    it "denies to manage comments by other" do
      Ability.new(other).can?(:manage, comment).should be_false
    end
    it "denies to create comments as guest" do
      Ability.new(guest).can?(:create, Comment.new).should be_false
    end
  end

end
