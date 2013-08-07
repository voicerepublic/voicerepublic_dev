require 'spec_helper'

describe Article do

  it "should hav a valid factory" do
    build(:article).should be_valid
  end

  it 'should set deleted_at on deletions' do
    article = create :article
    article.delete
    article = Article.only_deleted.find(article.id)
    article.deleted_at.should_not be_nil

    Article.all.should be_empty
    Article.only_deleted.count.should == 1
  end

end
