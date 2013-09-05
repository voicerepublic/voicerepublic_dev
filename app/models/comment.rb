class Comment < ActiveRecord::Base  
  attr_accessible :content, :commentable_id, :commentable_type, :user_id, :user, :url

  belongs_to :commentable, :polymorphic => true
  belongs_to :user

  validates :user_id, :presence => true
  validates :commentable_id, :presence => true
  validates :commentable_type, :presence => true
  validates :content, :presence => true
end
