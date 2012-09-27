class Notification::IncomingCall < Notification::Base 
  
  belongs_to :klu
  belongs_to :other, :class_name => 'User'  # other may be nil in case of anonymous call?
  
  validates :klu_id, :presence => true
  validates :url, :presence => true
  
  
end