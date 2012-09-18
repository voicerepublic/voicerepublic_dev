class Message < ActiveRecord::Base
  attr_accessible :content, :sender_read, :receiver_read, :receiver_id, :sender_id
  
  belongs_to :sender, :class_name => 'User'
  belongs_to :receiver, :class_name => 'User'
end
