require 'spec_helper'

describe Ability do

  before do
    @owner = FactoryGirl.create(:user)
    @other = FactoryGirl.create(:user)
  end
  
  describe User do

    it "allows to manage user by itself" do
      Ability.new(@owner).can?(:manage, @owner).should be_true
    end

    it "denies to manage user by other" do
      Ability.new(@other).can?(:manage, @owner).should be_false
    end

  end

  describe Account do

    it "allows to manage account by owner" do
      Ability.new(@owner).can?(:manage, @owner.account).should be_true
    end

    it "denies to manage account by other" do
      Ability.new(@other).can?(:manage, @owner.account).should be_false
    end

  end

  describe Venue do

    before do
      @venue = FactoryGirl.create(:venue, user: @owner)
    end
    
    it "allows to manage venues by owner" do
      Ability.new(@owner).can?(:manage, @venue).should be_true
    end

    it "denies to manage venues by other" do
      Ability.new(@other).can?(:manage, @venue).should be_false
    end

    it "allows to create venues as registered user (nonguest)" do
      Ability.new(@owner).can?(:create, Venue.new).should be_true
    end

    it "denies to create venues as guest" do
      guest = FactoryGirl.create(:user, guest: true)
      Ability.new(guest).can?(:create, Venue.new).should be_false
    end

  end

  describe Article do

    before do
      @article = FactoryGirl.create(:article, user: @owner)
    end

    it "allows to manage articles by owner" do
      Ability.new(@owner).can?(:manage, @article).should be_true
    end

    it "denies to manage articles by other" do
      Ability.new(@other).can?(:manage, @article).should be_false
    end
    
  end

  describe Comment do

    before do
      @comment = FactoryGirl.create(:comment, user: @owner)
    end

    it "allows to manage comments by owner" do
      Ability.new(@owner).can?(:manage, @comment).should be_true
    end
    
    it "denies to manage comments by other" do
      Ability.new(@other).can?(:manage, @comment).should be_false
    end
  
  end

end
