class Notification::MakeRate < Notification::Base
  # attr_accessible :title, :body
  attr_accessible :other_id, :user_id, :klu_id
 
  belongs_to :user
  belongs_to :other, :class_name => 'User'
  belongs_to :klu
   
  validates :other_id, :user_id, :klu_id, :presence => true
  
  after_create :generate_push_notification, :generate_mail_notification
  
  def to_s 
    I18n.t('model_notification_make_rate.please_rate', :name => other.name, :title => klu.title )
  end
end
