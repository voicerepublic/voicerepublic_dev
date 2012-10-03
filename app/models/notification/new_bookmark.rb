class Notification::NewBookmark < Notification::Base 
  attr_accessible :other_id, :user_id, :content
 
  belongs_to :user
  belongs_to :klu
  belongs_to :other, :class_name => 'User'
   
  validates :other_id, :user_id, :klu_id, :presence => true
end