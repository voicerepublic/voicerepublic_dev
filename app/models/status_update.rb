class StatusUpdate < ActiveRecord::Base
  #acts_as_commentable
  
  attr_accessible :content, :user_id
  belongs_to :user
  has_many :comments, :as => :commentable, :dependent => :destroy
  
  validates :user_id, :presence => true
  validates :content, :presence => true
  
end
