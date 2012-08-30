class StatusUpdate < ActiveRecord::Base
  #acts_as_commentable
  attr_accessible :content, :user_id
  belongs_to :user
  
  validates :user_id, :presence => true
  
end
