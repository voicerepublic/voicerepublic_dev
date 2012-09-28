require 'spec_helper'

describe SearchController do

  RSpec.configure do |config|
    config.use_transactional_fixtures = false
  end
  
  describe "GET 'search?query=foo'" do
    it "returns http success" do
      get :search , { :query => "foo" }
      response.should be_success
    end
    
    it "assigns the search results as @klus - but during test a searchd has to run..."  #do
    #  klus = Klu.search('foo')
    #  get :search , { :query => "foo" }
    #  assigns(:klus).kind_of?(Array).should be_true
    #end
  end

  describe "GET 'match'" do
    it "returns http success" do
      get 'match'
      response.should be_success
    end
  end

end
