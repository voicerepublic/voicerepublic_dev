# Attributes:
# * id [integer, primary, not null] - primary key
# * role_id [integer] - belongs to :role
# * user_id [integer] - belongs to :user
class UserRole < ActiveRecord::Base
  
  attr_accessible :role_id, :user_id
  
  belongs_to :user
  belongs_to :role
  
  validates :user_id, :role_id, :presence => true
  validates_uniqueness_of :role_id, :scope => :user_id
  
  
  
end
