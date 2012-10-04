class Notification::NewKluuu < Notification::Base 
  attr_accessible :other_id, :user_id, :content, :klu_id
  
  belongs_to :user
  belongs_to :other, :class_name => 'User'
   
  validates :other_id, :user_id, :presence => true
  
  def to_s
    I18n.t('.friend_created_new_kluuu', :friend => other.name, :title => klu.title )
  end
  
end