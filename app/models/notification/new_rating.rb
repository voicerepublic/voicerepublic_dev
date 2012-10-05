class Notification::NewRating < Notification::Base 
  attr_accessible :other_id, :user_id, :content
 
  belongs_to :user
  belongs_to :other, :class_name => 'User'
   
  validates :other_id, :user_id, :presence => true
  
  def to_s 
    I18n.t('.you_got_rated_by', :rater => other.name )
  end
  
end