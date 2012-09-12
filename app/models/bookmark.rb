class Bookmark < ActiveRecord::Base
  attr_accessible :description, :klu_id, :user_id
  
  belongs_to :user, :dependent => :destroy
  belongs_to :kluuu, :class_name => 'Kluuu', :foreign_key => :klu_id 
  belongs_to :no_kluuu, :class_name => 'NoKluuu',  :foreign_key => :klu_id 
  
  validates :klu_id, :presence => true
  validates :user_id, :presence => true
  
end
