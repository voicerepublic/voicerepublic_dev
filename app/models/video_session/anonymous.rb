class VideoSession::Anonymous < VideoSession::Base
  
  has_one :host_participant, :autosave => true, :class_name => 'Participant::Registered', :foreign_key => 'video_session_id', :dependent => :destroy
  has_one :guest_participant, :autosave => true, :class_name => 'Participant::Anonymous', :foreign_key => 'video_session_id', :dependent => :destroy
  
  before_validation :check_sezzion_create_prerequisites  # checks for things that should be in order before creating a sezzion
  
  before_create :prepare_one_on_one_video_session
  after_create :create_incoming_call_notification
  
  before_update :prepare_room_for_video_session
  after_create :create_call_accepted_notification
  
  before_destroy :create_call_canceled_notification
  
  validates_associated :host_participant, :guest_participant

 private
 
  def prepare_one_on_one_video_session   
   
    #create guest (calling) participant for video_session
    self.guest_participant =  Participant::Anonymous.new(:user_cookie_session_id => self.calling_user_id, :video_session_role => 'guest')
   
    #create host participant for video_session 
    self.host_participant = Participant::Registered.new(:user_id => @klu.user_id, :video_session_role => 'host')
  
  end
  
  def create_incoming_call_notification
    Notification::IncomingCall.create(:user_id => @klu.user_id, :anon_id => self.calling_user_id, :video_session_id => self.id)
  end
  
  def prepare_room_for_video_session
    #2, "#{t('sezzions_controller.update.chat_system_welcome')}", klu_show_url(:id => offer.id), request.host
    
    #raise KluuUException::RoomCreationFailed create_room_creation_failed_notification
      
  end
  
  def create_video_session_links_for_participants
    #raise KluuUException::LinkCreationFailed create_room_creation_failed_notification
  end  
  
  def create_call_accepted_notification  
  end
  
  def create_room_creation_failed_notification
  end
  
  def create_call_canceled_notification  
    if self.canceling_participant_id.to_i == self.guest_participant.id.to_i
      self.notifications.destroy_all
      Notification::MissedCall.create(:user_id => self.host_participant.user_id, :anon_id => self.guest_participant.user_cookie_session_id, :video_session_id => self.id)
    else
      self.notifications.destroy_all
      Notification::CallRejected.create(:anon_id => self.guest_participant.user_cookie_session_id, :other_id => self.host_participant.user_id, :video_session_id => self.id)
    end
  end
  
  def check_sezzion_create_prerequisites
    @klu = Klu.find(self.klu_id) unless self.klu_id.nil?    
    #is calling_user_id ok
    raise KluuuExceptions::CallingUserError.new(I18n.t('video_sessions_controller.create.failed_0'), 'shared/alert_flash') if (self.calling_user_id.nil? || (self.calling_user_id == ''))
    #is the klu unpublished or not existing?
    raise KluuuExceptions::KluUnavailableError.new(I18n.t('video_sessions_controller.create.failed_1'), 'shared/alert_flash') if (@klu.nil? || !@klu.published?)
    #is the klus user not available?
    raise KluuuExceptions::UserUnavailableError.new(I18n.t('video_sessions_controller.create.failed_3'), Rails.application.routes.url_helpers.new_message_path(:locale => I18n.locale, :receiver_id => @klu.user_id)) unless @klu.user.available?
    #if a anonymous user is calling a paid klu
    raise KluuuExceptions::AnonymousUserError.new(I18n.t('video_sessions_controller.create.failed_5'), Rails.application.routes.url_helpers.new_user_registration_path(:locale => I18n.locale)) if (klu.charge_type != 'free')
    end
end