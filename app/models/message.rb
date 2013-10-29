class Message < ActiveRecord::Base
  attr_accessible :content, :sender_read, :receiver_read, :receiver_id, :sender_id, :conversation_id
  
  belongs_to :sender, :class_name => 'User'
  belongs_to :receiver, :class_name => 'User'
  
  belongs_to :conversation
  
  #belongs_to :sender_conversation, :class_name => 'Conversation'
  #belongs_to :receiver_conversation, :class_name => 'Conversation'
  
  scope :sender_unread, where("sender_read = ?", false)
  scope :receiver_unread, where("receiver_read = ?", false)
  scope :receiver_undeleted, where("receiver_deleted=?", false)
  scope :sender_undeleted, where("sender_deleted=?", false)
  
  validates :receiver_id, :presence => true
  validates :sender_id, :presence => true
  validates :content, :presence => true
  
  before_create :add_to_or_create_conversation
  
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
  
  private
  
  def add_to_or_create_conversation
    ids = [sender.id, receiver.id].sort
    conv = Conversation.where("user_1_id=? AND user_2_id=?", ids[0],ids[1] ).first
    if conv.nil?
      conv = Conversation.create(:user_1_id => ids[0], :user_2_id => ids[1])
    end
    self.conversation = conv
  end
end
