class VideoSession::Anonymous < VideoSession::Base
 
  has_one :host_participant, :autosave => true, :class_name => 'Participant::HostRegistered', :foreign_key => 'video_session_id', :dependent => :destroy
  has_one :guest_participant, :autosave => true, :class_name => 'Participant::GuestAnonymous', :foreign_key => 'video_session_id', :dependent => :destroy
  
  before_create :prepare_one_on_one_video_session
  after_create :create_incoming_call_notification
  
  before_update :prepare_room_for_video_session, :if => Proc.new {|s| s.begin_timestamp.nil? }
  
  before_destroy :create_call_canceled_notification
  
  validates_associated :host_participant, :guest_participant

  def create_room_creation_failed_notification
    Notification::VideoSystemError.create(:anon_id => self.guest_participant.user_cookie_session_id, :other_id => self.host_participant.user_id, :video_session_id => self.id, :klu_id => self.klu_id)
  end

  def create_call_accepted_notification  
    Notification::CallAccepted.create(:anon_id => self.guest_participant.user_cookie_session_id, :other_id => self.host_participant.user_id, :video_session_id => self.id, :klu_id => self.klu_id)
  end

  def create_call_ended_notification(role)
    if (role == 'host')
      Notification::CallEnded.create(:user_id => self.host_participant.user_id, :video_session_id => self.id, :klu_id => self.klu_id)  
    else
      Notification::CallEnded.create(:anon_id => self.guest_participant.user_cookie_session_id, :video_session_id => self.id, :klu_id => self.klu_id)  
    end
  end

 private
 
  def prepare_one_on_one_video_session   
    
    check_sezzion_create_prerequisites()
    
    #create guest (calling) participant for video_session
    self.guest_participant =  Participant::GuestAnonymous.new(:user_cookie_session_id => self.calling_user_id, :video_session_role => 'guest')
   
    #create host participant for video_session 
    self.host_participant = Participant::HostRegistered.new(:user_id => self.klu.user_id, :video_session_role => 'host')
  
  end
  
  def create_incoming_call_notification
    Notification::IncomingCall.create(:user_id => self.klu.user_id, :anon_id => self.calling_user_id, :video_session_id => self.id, :klu_id => self.klu.id)
  end
  
  def prepare_room_for_video_session
    
    self.build_video_room(:name => self.klu.title)
    
    begin
      response = self.video_room.send_create
    rescue VideoSystemApi::VideoSystemApiException => e
      msg = I18n.t('video_sytem.rooms.errors.api_threw_exception')
      raise KluuuExceptions::VideoSystemError.new(msg, 'video_sessions/video_system_error', {:response => response})
    end
    
    if response.nil? || !response[:returncode]
      raise KluuuExceptions::VideoSystemError.new('no server available for this room', 'video_sessions/video_system_error', {:response => response})
    end
    
    create_video_session_links_for_participants
    
  end
  
  def create_video_session_links_for_participants
    begin
      self.guest_participant.create_link(self.video_room)
      self.host_participant.create_link(self.video_room)
    rescue Exception => e
      msg = I18n.t('video_sytem.rooms.errors.links.not_set')
      raise KluuuExceptions::VideoSystemError.new(msg, 'shared/_alert_flash')
    end
  end  
 
  def create_call_canceled_notification  
    if self.canceling_participant_id.to_i == self.guest_participant.id.to_i
      self.notifications.destroy_all
      Notification::MissedCall.create(:user_id => self.host_participant.user_id, :klu_id => self.klu_id, :anon_id => self.guest_participant.user_cookie_session_id, :video_session_id => self.id)
    else
      self.notifications.destroy_all
      Notification::CallRejected.create(:anon_id => self.guest_participant.user_cookie_session_id,:klu_id => self.klu_id, :other_id => self.host_participant.user_id, :video_session_id => self.id)
    end
  end
  
  def check_sezzion_create_prerequisites
    @klu = Klu.find(self.klu_id)
    #is the klu unpublished or not existing?
    raise KluuuExceptions::KluUnavailableError.new(I18n.t('video_sessions_controller.create.failed_1'), 'shared/alert_flash') if (!@klu.published?)
    #is the klus user not available?
    raise KluuuExceptions::UserUnavailableError.new(I18n.t('video_sessions_controller.create.failed_3'), 'user_unavailable', {:receiver_id => @klu.user_id}) unless @klu.user.available?
    #if a anonymous user is calling a paid klu
    raise KluuuExceptions::AnonymousUserError.new(I18n.t('video_sessions_controller.create.failed_5'), 'anonymous_sign_up') if (klu.charge_type != 'free')
  end
end