class Chat
  extend ActiveModel::Callbacks
  extend ActiveModel::Naming
  include ActiveModel::Validations
  include ActiveModel::Conversion
  include ActiveModel::Serializers::JSON
  
  #attr_accessible :user1  
  #attr_accessible :user2
  attr_accessor :sender, :user1, :user2
  attr_accessor :recipient
  attr_accessor :body
  
  #belongs_to :user1, :class_name => "User"
  #belongs_to :user2, :class_name => "User"
  #belongs_to :sender, :class_name => "User"
  #belongs_to :recipient, :class_name => "User"
 
 
  validates :user2, :presence => true
  validates :user1, :presence => true
  validates :sender, :presence => true
  validates :recipient, :presence => true
  validates :body, :presence => true
  
  define_model_callbacks :save
  
  after_save :send_push
  after_save :create_regular_message
  
  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value) 
    end
  end
  
  def save
    if self.valid?
      run_callbacks :save do
        self
      end
    end
  end
  
  def persisted?
    false
  end
  
  def recipient_for(user)
    user == user1 ? user2 : user1
  end
  
  def my_partner(me_user)
    me_user == user1 ? user2 : user1
  end
  
  def css_id_for_chat
    "chat-" + [sender.id, recipient.id].sort.join("-")
  end
  
  def channel_name
    "/chatchannel/" + [sender.id, recipient.id].sort.join("-")
  end
  
  private
  
  def send_push
    Rails.logger.debug("ChatMessage#send_push - about to send via push")
  end
  
  def create_regular_message
    Rails.logger.debug("ChatMessage#create_regular_message - about to create regular message")
  end
  
end