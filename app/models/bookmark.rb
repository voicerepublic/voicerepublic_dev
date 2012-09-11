class Bookmark < ActiveRecord::Base
  attr_accessible :description, :klu_id, :user_id
  
  belongs_to :user, :dependent => :destroy
  belongs_to :klu, :polymorphic => true
  
  validates :klu_id, :presence => true
  validates :user_id, :presence => true
  
  
  
end
