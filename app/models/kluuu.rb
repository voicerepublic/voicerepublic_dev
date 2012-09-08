class Kluuu < Klu
  
  # see base-class for base-validations
  validates :description, :presence => true
  validates :category_id, :presence => true
end
