class Kluuu < Klu
  
  # see base-class for base-validations
  validates :description, :presence => true
  validates :category_id, :presence => true
  
  has_many :klu_images
  accepts_nested_attributes_for :klu_images
  
end
