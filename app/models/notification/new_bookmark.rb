class Notification::NewBookmark < Notification::Base 
  attr_accessible :other_id, :user_id, :content, :klu_id
  attr_accessible :other, :user, :klu
 
  belongs_to :user
  belongs_to :klu, :class_name => 'Klu'
  belongs_to :other, :class_name => 'User'
   
  validates :other_id, :user_id, :klu_id, :presence => true
  
  after_create :generate_push_notification
  after_create :generate_mail_notification
  
  def to_s
    I18n.t('model_notification_new_bookmark.your_klu_got_bookmarked', :klu_title => klu.title, :bookmarker => other.name )
  end
  
end