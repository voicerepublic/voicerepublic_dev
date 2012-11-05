class Notification::NewRating < Notification::Base 
  attr_accessible :other_id, :user_id, :klu_id, :content
 
  belongs_to :user
  belongs_to :other, :class_name => 'User'
  belongs_to :klu
   
  validates :other_id, :user_id, :klu_id, :content , :presence => true
  
  after_create :generate_push_notification
  
  def to_s 
    I18n.t('.you_got_rated_by', :rater => other.name )
  end
  
end