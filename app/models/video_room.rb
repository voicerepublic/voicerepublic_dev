require 'video_system_api'


class VideoRoom < ActiveRecord::Base
  
  belongs_to :video_server
  belongs_to :video_session, :class_name => 'VideoSession::Base'

  attr_accessible :guest_password, :host_password, :video_system_room_id, :name, :video_server_id, :video_session_id, :welcome_msg
  
  validates :video_session_id, 
            :presence => true 
  validates :video_server_id, 
            :presence => true 
  validates :video_system_room_id, 
            :presence => true, 
            :uniqueness => true,
            :length => { :minimum => 1, :maximum => 100 }
  validates :name, 
            :presence => true, 
            :uniqueness => true,
            :length => { :minimum => 1, :maximum => 150 }
  validates :welcome_msg, :length => { :maximum => 250 }
  validates :guest_password, :presence => true
  validates :host_password, :presence => true

  # Note: these params need to be fetched from the server before being accessed
  attr_accessor :running, :participant_count, :participants,
                :has_been_forcibly_ended, :start_time, :end_time

  after_initialize :init
  
  def init 
    # fetched attributes
    self.participant_count = nil
    self.running = false
    self.has_been_forcibly_ended = false
    self.start_time = nil
    self.end_time = nil
    self.participants = []
  end
  
  def is_running?
    @running
  end
  
  # This method can be overridden to change the way the server is selected
  # before a room is created
  # This one selects the server with less rooms in it
  def select_server
     #TODO: Add Logic for Redundancy
     VideoServer.select("video_servers.*, count(video_rooms.id) as video_room_count").joins(:video_rooms).group("video_servers.id").order("video_room_count ASC").first
  end
 
  # Fetches info from the Video System about this room.
  # The response is parsed and stored in the model. You can access it using attributes such as:
  #
  #   room.participant_count
  #   room.participants[0].full_name
  #
  # The attributes changed are:
  # * <tt>participant_count</tt>
  # * <tt>running</tt>
  # * <tt>has_been_forcibly_ended</tt>
  # * <tt>start_time</tt>
  # * <tt>end_time</tt>
  # * <tt>participants</tt> (array of <tt>VideoSystemParticipant</tt>)
  # #
  # Triggers API call: <tt>get_meeting_info</tt>.
  def fetch_video_system_room_info
    require_server
    
    response = self.video_server.api.get_meeting_info(self.video_system_room_id, self.host_password)
 
    self.participant_count = response[:participantCount]
    self.running = response[:running]
    self.has_been_forcibly_ended = response[:hasBeenForciblyEnded]
    self.start_time = response[:startTime]
    self.end_time = response[:endTime]
    self.participants = []
    response[:attendees].each do |att|
      participant = VideoSystemApi::VideoSystemParticipant.new
      participant.from_hash(att)
      self.participants << participant
    end

    response
  end
 
  # # Sends a call to the Video Server to end the meeting.
  # #
  # # Triggers API call: <tt>end_meeting</tt>.
  def send_end
    require_server
    
    self.video_server.api.end_meeting(self.video_system_room_id, self.host_password)
  end
  
  
  # Fetches the Video System Room Info to see if the meeting is running. Sets <tt>running</tt>
  #
  # Triggers API call: <tt>is_meeting_running</tt>.
  def fetch_is_running?
    require_server
    
    @running = self.video_server.api.is_meeting_running?(self.video_system_room_id)
  end

  
  # Returns the URL to join this Room in the Video System.
  # username:: Name of the user
  # role: Role of the user in this room. Can be <tt>[:host, :guest]</tt>
  #
  # Uses the API but does not require a request to the server.
  def join_url(username, role, password=nil, user_id)
    require_server
 
    case role
    when :host
      self.video_server.api.join_meeting_url(self.video_system_room_id, username, self.host_password, user_id)
    else
      self.video_server.api.join_meeting_url(self.video_system_room_id, username, self.guest_password, user_id)
    end
  end

  # Sends a call to the Video Server to create the Video System Room.
  #
  # Will trigger 'select_server' to select a server where the meeting
  # will be created. If a server is selected, the model is saved.
  #
  # With the response, updates the following attributes:
  # * <tt>attendee_password</tt>
  # * <tt>moderator_password</tt>
  #
  # Triggers API call: <tt>create_meeting</tt>.
  def send_create
    # updates the server whenever a meeting will be created
    self.video_server = select_server
    self.save unless self.new_record?
    require_server
    
    self.video_system_room_id = random_video_system_room_id
    # create a new random meetingid everytime create fails with "duplicateWarning"
    count = 0
    try_again = true
    while try_again and count < 10
      response = do_create_video_system_room
      count += 1
      try_again = false
      unless response.nil?
        if response[:returncode] && response[:messageKey] == "duplicateWarning"
          self.video_system_room_id = random_video_system_room_id
          try_again = true
        end
      end
    end
    
    unless response.nil?
      self.guest_password = response[:attendeePW]
      self.host_password = response[:moderatorPW]
      self.save unless self.new_record?
    end
     
    response
  end

private
  
  def centisize(amount)
    return (amount.to_f * 100).round
  end
  
  def dollarize(amount)
    return (amount.to_f / 100).round(2)
  end

  def random_video_system_room_id
    SecureRandom.hex(16)
  end
# 
  # # The join logic
  # # A moderator can create the meeting and join
  # # An attendee can only join if the meeting is running
  # def perform_join(username, role, request=nil)
    # fetch_is_running?
# 
    # # if the user is a moderator, create the room (if needed) and join it
    # if role == :moderator
      # add_domain_to_logout_url(request.protocol, request.host_with_port) unless request.nil?
      # send_create unless is_running?
      # ret = join_url(username, role)
# 
    # # normal user only joins if the conference is running
    # # if it's not, wait for a moderator to create the conference
    # else
      # ret = join_url(username, role) if is_running?
    # end
# 
    # ret
  # end
# 
  # # add a domain name and/or protocol to the logout_url if needed
  # # it doesn't save in the db, just updates the instance
  # def add_domain_to_logout_url(protocol, host)
    # unless logout_url.nil?
      # url = logout_url.downcase
      # unless url.nil? or url =~ /^[a-z]+:\/\//           # matches the protocol
        # unless url =~ /^[a-z0-9]+([\-\.]{1}[a-z0-9]+)*/  # matches the host domain
          # url = host + url
        # end
        # url = protocol + url
      # end
      # self.full_logout_url = url.downcase
    # end
  # end
# 
  protected

  # Every room needs a server to be used.
  # The server of a room can change during the room's lifespan, but
  # it should not change if the room is running or if it was created
  # but not yet ended.
  # Any action that requires a server should call 'require_server' before
  # anything else.
  def require_server
    if self.video_server.nil?
      msg = I18n.t('video_sytem.rooms.errors.server.not_set')
      raise KluuuExceptions::VideoServerRequired.new(msg)
    end
  end

  def do_create_video_system_room
    msg = (self.welcome_msg.nil? or self.welcome_msg.empty?) ? default_welcome_message : self.welcome_msg
    self.video_server.api.create_meeting(self.name, self.video_system_room_id, msg, 
                                         self.video_session.klu.get_charge_type_as_integer, 
                                         self.video_session.klu.free_time,
                                         dollarize(self.video_session.klu.charge_amount), 
                                         self.video_session.klu.currency)
  end

  # Returns the default welcome message to be shown in a conference in case
  # there's no message set in this room.
  # Can be used to easily set a default message format for all rooms.
  def default_welcome_message
    I18n.t('video_system.rooms.default_welcome_msg', :name => self.name)
  end
end
