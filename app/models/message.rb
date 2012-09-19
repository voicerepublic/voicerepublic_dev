class Message < ActiveRecord::Base
  attr_accessible :content, :sender_read, :receiver_read, :receiver_id, :sender_id
  
  belongs_to :sender, :class_name => 'User'
  belongs_to :receiver, :class_name => 'User'
  
  scope :sender_unread, where("sender_read = ?", false)
  scope :receiver_unread, where("receiver_read = ?", false)
  
  validates :receiver_id, :presence => true
  validates :sender_id, :presence => true
  validates :content, :presence => true
  
  def destroy_for(user)
    if self.receiver == user
      sender_deleted ? self.destroy : self.update_attribute(:receiver_deleted, true)
      return true
    elsif self.sender == user
      receiver_deleted ? self.destroy : self.update_attribute(:sender_deleted, true)  
      return true    
    end
    false
  end
  
end
