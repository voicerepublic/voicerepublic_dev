class Notification::NewMessage < Notification::Base 
  
  belongs_to :user
  belongs_to :other, :class_name => 'User'
  
  attr_accessible :other_id, :user_id, :content
  
  validates :other_id, :user_id, :presence => true
end