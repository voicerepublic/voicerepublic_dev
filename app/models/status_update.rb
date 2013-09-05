class StatusUpdate < ActiveRecord::Base
  attr_accessible :content, :user_id

  belongs_to :user
  has_many :comments, :as => :commentable, :dependent => :destroy, :order => "created_at DESC"

  validates :user_id, :presence => true
  validates :content, :presence => true
end
