class UserRole < ActiveRecord::Base
  
  attr_accessible :role_id, :user_id
  
  belongs_to :user
  belongs_to :role
  
end