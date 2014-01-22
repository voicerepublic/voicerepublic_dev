require 'spec_helper'

describe Article do

  describe 'built' do
    before do 
      @article = FactoryGirl.build(:article)
    end
    it "has a valid factory" do
      expect(@article).to be_valid
    end
    it 'validates presence of venue' do
      @article.venue = nil
      expect(@article).to_not be_valid
    end
    it 'validates presence of user' do
      @article.user = nil
      expect(@article).to_not be_valid
    end
    it 'validates presence of content' do
      @article.content = nil
      expect(@article).to_not be_valid
    end
  end

  describe 'created' do
    before do
      @article = FactoryGirl.create(:article)
    end
    it 'delegates to venue_user' do
      expect(@article.venue_user).to eq(@article.venue.user)
    end
    it 'should set deleted_at on deletions' do
      expect { @article.delete }.to change { Article.count }.by(-1)
      expect(Article.only_deleted).to include(@article)
      expect(Article.all).to_not include(@article)
    end
  end
  
end
