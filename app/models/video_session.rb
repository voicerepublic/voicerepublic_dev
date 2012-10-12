class VideoSession < ActiveRecord::Base
  attr_accessible :begin_timestamp, :end_timestamp, :klu_id, :video_system_session_id, :calling_user_id, :calling_user_type
  attr_accessor :calling_user_id, :calling_user_type
  
  has_many :participants, :autosave => true, :class_name => 'Participant::Base'
  belongs_to :klu, :inverse_of => :video_sessions
  
  before_create :prepare_one_on_one_video_session
  after_create :create_incoming_call_notification
  
  validates_associated :participants
  validates_presence_of :klu, :calling_user_id, :calling_user_type
  

 private
 
 def prepare_one_on_one_video_session   
   
   @klu_user = Klu.find(self.klu_id).user
   
   #create guest (calling) participant for video_session
   if self.calling_user_type == 'registered'
     self.participants << Participant::Registered.new(:user_id => calling_user_id, :video_session_role => 'guest')
   else
     self.participants << Participant::Anonymous.new(:user_cookie_session_id => calling_user_id, :video_session_role => 'guest')
   end
   #create host participant for video_session 
   self.participants << Participant::Registered.new(:user_id => @klu_user.id, :video_session_role => 'host')
  end
  
  def create_incoming_call_notification
    if self.calling_user_type == 'registered'
      Notification::IncomingCall.create(:user_id => @klu_user.id, :other_id => calling_user_id, :video_session_id => self.id)
    else
      Notification::IncomingCall.create(:user_id => @klu_user.id, :anon_id => calling_user_id, :video_session_id => self.id)
    end  
  end
end
