class Bookmark < ActiveRecord::Base
  attr_accessible :description, :kluuu_id, :user_id
  
  belongs_to :user, :dependent => :destroy
  
  validates :kluuu_id, :presence => true
  validates :user_id, :presence => true
  
  
  
end
