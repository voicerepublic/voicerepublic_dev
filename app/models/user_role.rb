class UserRole < ActiveRecord::Base
  
  attr_accessible :role_id, :user_id
  
  belongs_to :user
  belongs_to :role
  
  validates :user_id, :role_id, :presence => true
  validates_uniqueness_of :role_id, :scope => :user_id
  
  
  
end