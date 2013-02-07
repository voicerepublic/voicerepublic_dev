class Notification::NewVenueParticipant < Notification::Base 
  attr_accessible :other_id, :user_id, :klu_id, :klu, :content, :other, :user
  
  belongs_to :user
  belongs_to :other, :class_name => 'Venue'   
  belongs_to :klu, :class_name => "Klu"       # participating klu
   
  validates :other_id, :user_id, :klu_id, :presence => true
  
  after_create :generate_mail_notification, :generate_push_notification
  
  def to_s
    I18n.t('model_notification_new_venue_participant.new_participant', :title => other.title, :name => klu.user.name )
  end
  
end