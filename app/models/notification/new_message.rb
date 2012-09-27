class Notification::NewMessage < Notification::Base 
  belongs_to :other, :class_name => 'User'
  
  validates :other_id, :presence => true
end