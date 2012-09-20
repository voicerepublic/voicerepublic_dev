class Kluuu < Klu
  
  
  
  CHARGE_TYPES = %w{free minute fix}
  has_many :bookmarks, :dependent => :destroy, :foreign_key => :klu_id
  
  has_many :klu_images, :foreign_key => :klu_id, :dependent => :destroy
  accepts_nested_attributes_for :klu_images
  
  # see base-class for base-validations
  validates :description, :presence => true
  validates :category_id, :presence => true
  
  
end
