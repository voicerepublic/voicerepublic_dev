require 'spec_helper'
require 'thinking_sphinx/test'
require 'database_cleaner'
#require 'support/sphinx_environment'


describe SearchController do

    before(:all)  do
      self.use_transactional_fixtures = false
      DatabaseCleaner.strategy = :truncation#, {:only => tables}
      ThinkingSphinx::Test.create_indexes_folder
      ThinkingSphinx::Test.start
    end

    before(:each) do
      DatabaseCleaner.start
      %w(admin user).each { |x| Role.create(:name => x)}
    end
    
    after(:all) do
      DatabaseCleaner.clean
      ThinkingSphinx::Test.stop
      DatabaseCleaner.strategy = :transaction
      self.use_transactional_fixtures = true
      %w(admin user).each { |x| Role.create(:name => x) }
    end

    describe "GET 'search?query=foo'" do
      it "returns http success" do
        get :search , { :query => "foo" }
        response.should be_success
      end

      # it "assigns the search results as @klus - but during test a searchd has to run... so if running specs with guard this error is okay"  do
      # klu = FactoryGirl.create(:published_kluuu, title: "ein testtitel")
      #   ThinkingSphinx::Test.index
      #   get :search , { :query => "testtitel" }
      #   assigns(:klus).kind_of?(Array).should be_true
      #   assigns(:klus).should eq([klu])
      # end
    end

    describe "GET 'match'" do
      it "returns http success" do
        get 'match'
        response.should be_success
      end
    end

end
