class Chat
  extend ActiveModel::Callbacks
  extend ActiveModel::Naming
  include ActiveModel::Validations
  include ActiveModel::Conversion
  include ActiveModel::Serializers::JSON
  
  attr_accessor :user1  # is recipient
  attr_accessor :user2  # is sender
  attr_accessor :body
  
  validates :user2, :presence => true
  validates :user1, :presence => true
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
  
  def css_id_for_chat
    "chat-" + [user1.id,user2.id].sort.join("-")
  end
  
  private
  
  def send_push
    Rails.logger.debug("ChatMessage#send_push - about to send via push")
  end
  
  def create_regular_message
    Rails.logger.debug("ChatMessage#create_regular_message - about to create regular message")
  end
  
end