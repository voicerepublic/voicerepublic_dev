class Notification::MissedCall < Notification::Base 
  
  belongs_to :user
  belongs_to :klu
  belongs_to :other, :class_name => 'User'  # other may be nil in case of anonymous call?
  
  validates :klu_id, :url, :user_id, :presence => true
  
  after_create :generate_push_notification
  
  
  def to_s
    I18n.t('.you_missed_a_call_on_your_klu', :caller => other ? other.name : 'anonymous', :klu => klu.title )
  end
  
  
end