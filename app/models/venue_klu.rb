class VenueKlu < ActiveRecord::Base
  
  attr_accessible :klu_id, :venue_id
  
  belongs_to :klu, :class_name => 'Klu'
  belongs_to :venue
  
  validates :klu_id, :venue_id, :presence => true
  
end
