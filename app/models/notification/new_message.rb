class Notification::NewMessage < Notification::Base 
  attr_accessible :other_id, :user_id, :content
 
  belongs_to :user
  belongs_to :other, :class_name => 'User'
   
  validates :other_id, :user_id, :presence => true
  
  def to_s
    I18n.t('.new_message_from', :sender => other.name, :default => 'you have a new message')
  end
  
end