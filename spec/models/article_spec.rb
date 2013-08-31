require 'spec_helper'

describe Article do

  it "should hav a valid factory" do
    FactoryGirl.build(:article).should be_valid
  end

  it 'should set deleted_at on deletions' do
    article = FactoryGirl.create :article
    expect { article.delete }.to change { Article.count }.by(-1)
    expect(Article.only_deleted).to include(article)
    expect(Article.all).to_not include(article)
  end

end
