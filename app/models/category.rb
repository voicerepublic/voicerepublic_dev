# Attributes:
# * id [integer, primary, not null] - primary key
# * created_at [datetime, not null] - creation time
# * lft [integer] - TODO: document me
# * name [string]
# * parent_id [integer] - TODO: document me
# * rgt [integer] - TODO: document me
# * updated_at [datetime, not null] - last update time
class Category < ActiveRecord::Base
  attr_accessible :lft, :name, :parent_id, :rgt
  translates :name, :fallbacks_for_empty_translations => true
  
  validates :name, :presence => true
  validates_uniqueness_of :name
  
  has_many :klus
  
  def to_s
    name
  end
end
