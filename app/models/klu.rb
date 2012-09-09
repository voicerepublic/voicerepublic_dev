class Klu < ActiveRecord::Base
  attr_accessible :available_at_times, :category_id, :description, :published, :title, :type, :user_id
  
  belongs_to :user
  belongs_to :category
  has_many :bookmarks, :dependent => :destroy, :foreign_key => :klu_id
  
  validates :title, :presence => true
  validates :user_id, :presence => true
  
end
