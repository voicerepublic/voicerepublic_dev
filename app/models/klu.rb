class Klu < ActiveRecord::Base
  
  has_many :video_sessions, :inverse_of => :klu
  
  attr_accessible :available_at_times, :category_id, :description, :published, :title, :type, :user_id, :tag_list
  #because of sti here in superclass
  attr_accessible :charge_type, :charge_amount, :currency
  
  acts_as_taggable
  
  belongs_to :user
  belongs_to :category
  
  validates_presence_of :title, :user_id

  scope :published, where("published=?", true)
  
  
end
