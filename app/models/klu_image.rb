class KluImage < ActiveRecord::Base
  attr_accessible :description, :klu_id, :image
  has_attached_file :image, :styles => { :large => "900x900>", :medium => "450x450>", :thumb => "50x50>" }
  
  belongs_to :kluuu, :class_name => 'Kluuu', :foreign_key => :klu_id, :dependent => :destroy
  
  validates :klu_id, :presence => true

end
