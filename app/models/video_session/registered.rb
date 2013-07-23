# Attributes:
# * id [integer, primary, not null] - primary key
# * begin_timestamp [datetime] - TODO: document me
# * created_at [datetime, not null] - creation time
# * end_timestamp [datetime] - TODO: document me
# * klu_id [integer] - belongs to :klu
# * type [string] - TODO: document me
# * updated_at [datetime, not null] - last update time
# * video_system_session_id [string] - TODO: document me
class VideoSession::Registered < VideoSession::Base
  
  has_one :host_participant, :autosave => true, :class_name => 'Participant::HostRegistered', :foreign_key => 'video_session_id', :dependent => :destroy
  has_one :guest_participant, :autosave => true, :class_name => 'Participant::GuestRegistered', :foreign_key => 'video_session_id', :dependent => :destroy
  has_many :transfers, :foreign_key => 'video_session_id' 
  
  
  before_create :prepare_one_on_one_video_session
  after_create :create_incoming_call_notification
  
  before_update :prepare_room_for_video_session, :if => Proc.new {|s| s.begin_timestamp.nil? }
  
  before_destroy :create_call_canceled_notification
  
  validates_associated :host_participant, :guest_participant


  def create_room_creation_failed_notification
    Notification::VideoSystemError.create(:user_id => self.guest_participant.user_id, :other_id => self.host_participant.user_id, :video_session_id => self.id, :klu_id => self.klu_id)
  end

  def create_call_accepted_notification  
    Notification::CallAccepted.create(:user_id => self.guest_participant.user_id, :other_id => self.host_participant.user_id, :video_session_id => self.id, :klu_id => self.klu_id)
  end
  
  def create_call_ended_notification(role)
    Notification::CallEnded.create(:user_id => self.host_participant.user_id, :video_session_id => self.id,  :klu_id => self.klu_id)  
    Notification::CallEnded.create(:user_id => self.guest_participant.user_id, :video_session_id => self.id,  :klu_id => self.klu_id)  
  end

 private
 
  def prepare_one_on_one_video_session  
    
    check_sezzion_create_prerequisites()
   
    #create guest (calling) participant for video_session
    self.guest_participant = Participant::GuestRegistered.new(:user_id => self.calling_user_id, :video_session_role => 'guest')
   
    #create host participant for video_session 
    self.host_participant = Participant::HostRegistered.new(:user_id => @klu.user_id, :video_session_role => 'host')
  
  end
  
  def create_incoming_call_notification
    Notification::IncomingCall.create(:user_id => @klu.user_id, :other_id => self.calling_user_id, :video_session_id => self.id, :klu_id => self.klu_id)  
  end
  
  def prepare_room_for_video_session
    
    self.build_video_room(:name => self.klu.title)
    begin
      response = self.video_room.send_create
    rescue VideoSystemApi::VideoSystemApiException => e
      Rails.logger.error("VideoSession::Registered#prepare_room_for_video_session - ERROR rescued Exception: #{e.inspect}")
      msg = I18n.t('video_sytem.rooms.errors.api_threw_exception')
      raise KluuuExceptions::VideoSystemError.new(msg, 'video_sessions/video_system_error', {:response => response})
    end
    
    if response.nil? || !response[:returncode]
      Rails.logger.error("VideoSession::Registered#prepare_room_for_video_session - ERROR - response is nil raising exception now.")
      raise KluuuExceptions::VideoSystemError.new('no server available for this room', 'video_sessions/video_system_error', {:response => response})
    end
    
    create_video_session_links_for_participants
      
  end
  
  def create_video_session_links_for_participants
    begin
      self.guest_participant.create_link(self.video_room)
      self.host_participant.create_link(self.video_room)
    rescue Exception => e
      Rails.logger.error("VideoSession::Registered#create_video_session_links_for_participants - ERROR - rescuing: #{e.inspect}")
      msg = I18n.t('video_sytem.rooms.errors.links.not_set')
      raise KluuuExceptions::VideoSystemError.new(msg, 'video_sessions/video_system_error')
    end
  end  
  
  def create_call_canceled_notification 
    if self.canceling_participant_id.to_i == self.guest_participant.id.to_i
      self.notifications.destroy_all
      Notification::MissedCall.create(:user_id => self.host_participant.user_id, :other_id => self.guest_participant.user_id, :klu_id => self.klu_id, :video_session_id => self.id, :url => Rails.application.routes.url_helpers.user_path(:id => self.guest_participant.user_id))
    else  
      self.notifications.destroy_all
      Notification::CallRejected.create(:user_id => self.guest_participant.user_id, :other_id => self.host_participant.user_id, :klu_id => self.klu_id, :video_session_id => self.id)
    end
  end
  
  def check_sezzion_create_prerequisites
    @klu = Klu.find(self.klu_id)
    @calling_user = User.find(self.calling_user_id)
    #is the klu unpublished or not existing?
    raise KluuuExceptions::KluUnavailableError.new(I18n.t('video_sessions_controller.create.failed_1'), 'shared/alert_flash') if (@klu.instance_of?(Kluuu) && (!@klu.published?))
    #is the user trying to call his own klu?
    raise KluuuExceptions::SameUserError.new(I18n.t('video_sessions_controller.create.failed_2'), 'shared/alert_flash') if (@calling_user.id == @klu.user_id)
    #is the klus user not available?
    raise KluuuExceptions::UserUnavailableError.new(I18n.t('video_sessions_controller.create.failed_3'), 'user_unavailable', {:receiver_id => @klu.user_id}) unless @klu.user.available?
    #if a registered user is calling a paid klu then make sure he has money
    raise KluuuExceptions::NoAccountError.new(I18n.t('video_sessions_controller.create.failed_4'), 'no_account') if (@klu.charge_type != 'free') && (@calling_user.balance_account.nil?)
    #make sure the caller has at least credit for one paid minute
    raise KluuuExceptions::NoFundsError.new(I18n.t('video_sessions_controller.create.failed_6'), 'no_funds') if ((@klu.charge_type != 'free') && (!@calling_user.balance_account.check_balance(@klu.charge, @klu.charge_type, 1)))
 
  end
end
