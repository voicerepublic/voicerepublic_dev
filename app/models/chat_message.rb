class ChatMessage
  extend ActiveModel::Callbacks
  extend ActiveModel::Naming
  include ActiveModel::Validations
  include ActiveModel::Serializers::JSON
  
  attr_accessor :user_id
  attr_accessor :recipient_id
  attr_accessor :body
  
  validates :user_id, :presence => true
  validates :recipient_id, :presence => true
  validates :body, :presence => true
  
  define_model_callbacks :save
  
  after_save :send_push
  after_save :generate_regular_message
  
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
  
  private
  
  def send_push
    Rails.logger.debug("ChatMessage#send_push - about to send via push")
  end
  
  def create_regular_message
    Rails.logger.debug("ChatMessage#create_regular_message - about to create regular message")
  end
  
end