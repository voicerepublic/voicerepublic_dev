# Attributes:
# * id [integer, primary, not null] - primary key
# * name [string]
class Role < ActiveRecord::Base
  attr_accessible :name
  
  has_many :user_roles
  has_many :user, :through => :user_roles
  
  validates_uniqueness_of :name
  
  def to_s
    name
  end
end
