class Conversation < ActiveRecord::Base
  #attr_accessible :partner_id, :user_id
  attr_accessible :user_1_id, :user_2_id
  #has_many :receiver_messages, :class_name => 'Message', :foreign_key => :receiver_conversation_id
  #has_many :sender_messages, :class_name => 'Message', :foreign_key => :sender_conversation_id
  
  has_many :messages
  belongs_to :user_1, :class_name => 'User'
  belongs_to :user_2, :class_name => 'User'
  #belongs_to :user
  #belongs_to :partner, :class_name => 'User'
  
  #before_destroy :cleanup_messages
  
  
  validates :user_1, :presence => true
  validates :user_2, :presence => true
  
  
  #def messages
  #  arr = receiver_messages.receiver_undeleted.to_a
  #  arr << sender_messages.sender_undeleted.to_a
  #  arr.flatten!
  #  arr.sort { |x,y| y.created_at <=> x.created_at }
  #end
  
  def partner_of(user)
    self.user_1_id == user.id ? self.user_2 : self.user_1
  end
  
  
  private
  
  def cleanup_messages
    [receiver_messages, sender_messages].each do |messages|
      messages.each do |msg|
        if msg.sender == user
          msg.update_attribute(:sender_deleted, true)
        elsif msg.receiver == user
          msg.update_attribute(:receiver_deleted, true)
        end
      end
    end
  end
end
