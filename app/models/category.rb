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
