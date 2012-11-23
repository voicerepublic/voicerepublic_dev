class Notification::NewKluuu < Notification::Base 
  attr_accessible :other_id, :user_id, :content, :klu_id, :other, :user, :klu
  
  belongs_to :user
  belongs_to :other, :class_name => 'User'
  belongs_to :klu
   
  validates :other_id, :user_id, :klu_id,  :presence => true
  
  after_create :generate_mail_notification
  
  def to_s
    I18n.t('model_notification_new_kluuu.friend_created_new_kluuu', :name => other.name)
  end
  
end