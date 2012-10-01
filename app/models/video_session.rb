class VideoSession < ActiveRecord::Base
  
  has_many :participants, :autosave => true
  belongs_to :klu, :inverse_of => :video_sessions
  
  attr_accessible :begin_timestamp, :end_timestamp, :klu_id, :video_system_session_id, :calling_user_id, :calling_user_type
  attr_accessor :calling_user_id, :calling_user_type
  
  before_create :prepare_one_on_one_video_session
  
  validates_associated :participants
  validates_presence_of :klu, :calling_user_id, :calling_user_type
  
  after_create :create_incoming_call_notification
  
 def prepare_one_on_one_video_session
   
   klu_user = Klu.find(self.klu_id).user
   
   #create guest (calling) participant for video_session
   if self.calling_user_type == 'registered'
     self.participants << RegisteredParticipant.new(:user_id => calling_user_id, :video_session_role => 'guest')
   else
     self.participants << AnonymousParticipant.new(:user_cookie_session_id => calling_user_id, :video_session_role => 'guest')
   end
   
   #create host participant for video_session 
   self.participants << RegisteredParticipant.new(:user_id => klu_user.id, :video_session_role => 'host')
   
  end
  
  def create_incoming_call_notification
    #klu_user << IncomingCallNotification.create(:calling_user_id => self.calling_user_id, :klu_id => self.klu_id)
  end
  
end
