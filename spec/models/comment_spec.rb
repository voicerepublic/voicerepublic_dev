require 'rails_helper'

describe Comment do

  describe 'built' do
    before do
      @comment = FactoryGirl.build(:comment)
    end
    it 'has a valid factory' do
      expect(@comment).to be_valid
    end
    it 'validates presence of user' do
      @comment.user = nil
      expect(@comment).to_not be_valid
    end
    it 'validates presence of commentable' do
      @comment.commentable = nil
      expect(@comment).to_not be_valid
    end
    it 'validates presence of content' do
      @comment.content = nil
      expect(@comment).to_not be_valid
    end
  end

end
