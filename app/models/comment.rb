class Comment < ActiveRecord::Base
  
  attr_accessible :content, :commentable_id, :commentable_type, :user_id

  belongs_to :commentable, :polymorphic => true
  belongs_to :user
  #default_scope :order => 'created_at DESC'
  
  

  # NOTE: install the acts_as_votable plugin if you
  # want user to vote on the quality of comments.
  #acts_as_voteable

  # NOTE: Comments belong to a user
  
  
  validates :user_id, :presence => true
  validates :commentable_id, :presence => true
  validates :commentable_type, :presence => true
  validates :content, :presence => true
  
end
