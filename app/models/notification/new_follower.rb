class Notification::NewFollower < Notification::Base 
  attr_accessible :other_id, :user_id, :other, :user
   
  belongs_to :user
  belongs_to :other, :class_name => 'User'
  
  validates :other_id, :user_id, :presence => true
  
  #after_create :generate_push_notification
  
  
  def to_s
    I18n.t('.you_got_a_new_follower', :follower => other.name )
  end
  
end