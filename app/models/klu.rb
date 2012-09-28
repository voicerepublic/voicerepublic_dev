class Klu < ActiveRecord::Base
  
  attr_accessible :available_at_times, :category_id, :description, :published, :title, :type, :user_id, :tag_list
  acts_as_taggable
  
  belongs_to :user
  belongs_to :category
  
  validates_presence_of :title, :user_id

  scope :published, where("published=?", true)
  
  
end
