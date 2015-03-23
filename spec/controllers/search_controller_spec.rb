# encoding: utf-8
require 'spec_helper'

describe SearchController do

  describe "on POST" do
    it "redirects" do
      post :create, query: 'some query'
      response.should be_redirect
    end
  end

  describe "on GET" do

    before do
      Thread.current["PgSearch.enable_multisearch"] = true
    end

    after do
      Thread.current["PgSearch.enable_multisearch"] = false
    end

    it "succeeds" do
      get :show, page: 1, query: 'some query'
      response.should be_success
    end

    it "populates results" do
      expect(PgSearch::Document.count).to eq(0)
      venue = FactoryGirl.create(:venue, title: 'Fear and Delight')
      expect(PgSearch::Document.count).to be > 0
      get :show, page: 1, query: 'Delight'
      assigns(:results).should_not be_empty
    end

    it "finds users" do
      user = FactoryGirl.create(:user, firstname: 'Fear and Delight')
      get :show, page: 1, query: 'Delight'
      assigns(:results).first.searchable.should eq(user)
    end

    it "finds venues" do
      venue = FactoryGirl.create(:venue, title: 'Fear and Delight')
      get :show, page: 1, query: 'Delight'
      assigns(:results).first.searchable.should eq(venue)
    end

    it "finds talks" do
      talk = FactoryGirl.create(:talk, title: 'Fear and Delight')
      get :show, page: 1, query: 'Delight'
      assigns(:results).first.searchable.should eq(talk)
    end

    it "finds results when forgetting the accent" do
      talk = FactoryGirl.create(:talk, title: 'Fèar and Delight')
      get :show, page: 1, query: 'Delight'
      assigns(:results).first.searchable.should eq(talk)
    end

    it "finds results when using wrong accents" do
      talk = FactoryGirl.create(:talk, title: 'tálk with âccèntś')
      get :show, page: 1, query: 'áccéntš'
      assigns(:results).first.searchable.should eq(talk)
    end

    it "finds multiple models at once" do
      user = FactoryGirl.create(:user, firstname: 'Fear and Delight')
      venue = FactoryGirl.create(:venue, title: 'Fear and Delight')
      talk = FactoryGirl.create(:talk, title: 'Fear and Delight')
      get :show, page: 1, query: 'Delight'
      assigns(:results).count.should eq(3)
      searchables = assigns(:results).map(&:searchable)
      searchables.should include(user)
      searchables.should include(venue)
      searchables.should include(talk)
    end
  end

end
