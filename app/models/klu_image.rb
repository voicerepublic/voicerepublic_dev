class KluImage < ActiveRecord::Base
  attr_accessible :description, :klu_id, :image
  
  # FIXME: for upgrade of old kluuu:
  attr_accessible :image_file_name, :image_content_type, :image_file_size
  
  has_attached_file :image, :styles => { :large => "760x570#", :medium => "360x270#", :thumb => "120x90#" }
  
  belongs_to :kluuu, :class_name => 'Kluuu', :foreign_key => :klu_id
  
  #validates :klu_id, :presence => true # validation ripped because of nested forms wont work.

end
