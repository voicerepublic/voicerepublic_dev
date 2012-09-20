class Klu < ActiveRecord::Base
  
  attr_accessible :available_at_times, :category_id, :description, :published, :title, :type, :user_id, :charge_type, :charge_amount, :tag_list
  acts_as_taggable
  
  belongs_to :user
  belongs_to :category
  
  validates :title, :presence => true
  validates :user_id, :presence => true
  
  scope :published, where("published=?", true)
  
  
end
