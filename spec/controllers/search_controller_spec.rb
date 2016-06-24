# encoding: utf-8
require 'rails_helper'

describe SearchController do

  describe "on POST" do
    it "redirects" do
      post :create, query: 'some query'
      expect(response).to be_redirect
    end
  end

  describe "on GET" do

    # before do
    #   Thread.current["PgSearch.enable_multisearch"] = true
    # end
    #
    # after do
    #   Thread.current["PgSearch.enable_multisearch"] = false
    # end

    it "succeeds" do
      get :show, page: 1, query: 'some query'
      expect(response).to be_success
    end

    it "populates results" do
      #expect(PgSearch::Document.count).to eq(0)
      talk = FactoryGirl.create(:talk, title: 'Fear and Delight')
      #expect(PgSearch::Document.count).to be > 0
      get :show, page: 1, query: 'Delight'
      expect(assigns(:talks)).not_to be_empty
    end

    # it "finds users" do
    #   user = FactoryGirl.create(:user, firstname: 'Fear and Delight')
    #   get :show, page: 1, query: 'Delight'
    #   expect(assigns(:talks).first.searchable).to eq(user)
    # end

    # it "finds series" do
    #   series = FactoryGirl.create(:series, title: 'Fear and Delight')
    #   get :show, page: 1, query: 'Delight'
    #   expect(assigns(:talks).first.searchable).to eq(series)
    # end

    it "finds talks" do
      talk = FactoryGirl.create(:talk, title: 'Fear and Delight')
      get :show, page: 1, query: 'Delight'
      expect(assigns(:talks).first).to eq(talk)
    end

    it "finds results when forgetting the accent" do
      talk = FactoryGirl.create(:talk, title: 'Fèar and Delight')
      get :show, page: 1, query: 'Delight'
      expect(assigns(:talks).first).to eq(talk)
    end

    it "finds results when using wrong accents" do
      talk = FactoryGirl.create(:talk, title: 'tálk with âccèntś')
      get :show, page: 1, query: 'áccéntš'
      expect(assigns(:talks).first).to eq(talk)
    end

    # it "finds multiple models at once" do
    #   user = FactoryGirl.create(:user, firstname: 'Fear and Delight')
    #   series = FactoryGirl.create(:series, title: 'Fear and Delight')
    #   talk = FactoryGirl.create(:talk, title: 'Fear and Delight')
    #   get :show, page: 1, query: 'Delight'
    #   expect(assigns(:talks).count).to eq(3)
    #   searchables = assigns(:talks).map(&:searchable)
    #   expect(searchables).to include(user)
    #   expect(searchables).to include(series)
    #   expect(searchables).to include(talk)
    # end
  end

end
