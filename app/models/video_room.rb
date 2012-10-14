
class VideoRoom < ActiveRecord::Base
  
  belongs_to :video_server
  belongs_to :video_session

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
    self.video_system_room_id = SecureRandom.hex(16)
    self.host_password = SecureRandom.base64(16)
    self.guest_password = SecureRandom.base64(16)
     
    # fetched attributes
    @participant_count = 0
    @running = false
    @has_been_forcibly_ended = false
    @start_time = nil
    @end_time = nil
    @participants = []
  end
  
  def is_running?
    @running
  end
 
  # # Fetches info from BBB about this room.
  # # The response is parsed and stored in the model. You can access it using attributes such as:
  # #
  # #   room.participant_count
  # #   room.attendees[0].full_name
  # #
  # # The attributes changed are:
  # # * <tt>participant_count</tt>
  # # * <tt>moderator_count</tt>
  # # * <tt>running</tt>
  # # * <tt>has_been_forcibly_ended</tt>
  # # * <tt>start_time</tt>
  # # * <tt>end_time</tt>
  # # * <tt>attendees</tt> (array of <tt>BigbluebuttonAttendee</tt>)
  # #
  # # Triggers API call: <tt>get_meeting_info</tt>.
  # def fetch_meeting_info
    # require_server
# 
    # response = self.server.api.get_meeting_info(self.meetingid, self.moderator_password)
# 
    # @participant_count = response[:participantCount]
    # @moderator_count = response[:moderatorCount]
    # @running = response[:running]
    # @has_been_forcibly_ended = response[:hasBeenForciblyEnded]
    # @start_time = response[:startTime]
    # @end_time = response[:endTime]
    # @attendees = []
    # response[:attendees].each do |att|
      # attendee = BigbluebuttonAttendee.new
      # attendee.from_hash(att)
      # @attendees << attendee
    # end
# 
    # response
  # end
# 
  # # Fetches the BBB server to see if the meeting is running. Sets <tt>running</tt>
  # #
  # # Triggers API call: <tt>is_meeting_running</tt>.
  # def fetch_is_running?
    # require_server
    # @running = self.server.api.is_meeting_running?(self.meetingid)
  # end
# 
  # # Sends a call to the BBB server to end the meeting.
  # #
  # # Triggers API call: <tt>end_meeting</tt>.
  # def send_end
    # require_server
    # self.server.api.end_meeting(self.meetingid, self.moderator_password)
  # end
# 
  # # Sends a call to the BBB server to create the meeting.
  # #
  # # Will trigger 'select_server' to select a server where the meeting
  # # will be created. If a server is selected, the model is saved.
  # #
  # # With the response, updates the following attributes:
  # # * <tt>attendee_password</tt>
  # # * <tt>moderator_password</tt>
  # #
  # # Triggers API call: <tt>create_meeting</tt>.
  # def send_create
    # # updates the server whenever a meeting will be created
    # self.server = select_server
    # self.save unless self.new_record?
    # require_server
# 
    # unless self.randomize_meetingid
      # response = do_create_meeting
# 
    # # create a new random meetingid everytime create fails with "duplicateWarning"
    # else
      # self.meetingid = random_meetingid
# 
      # count = 0
      # try_again = true
      # while try_again and count < 10
        # response = do_create_meeting
# 
        # count += 1
        # try_again = false
        # unless response.nil?
          # if response[:returncode] && response[:messageKey] == "duplicateWarning"
            # self.meetingid = random_meetingid
            # try_again = true
          # end
        # end
# 
      # end
    # end
# 
    # unless response.nil?
      # self.attendee_password = response[:attendeePW]
      # self.moderator_password = response[:moderatorPW]
      # self.save unless self.new_record?
    # end
# 
    # response
  # end
# 
  # # Returns the URL to join this room.
  # # username:: Name of the user
  # # role:: Role of the user in this room. Can be <tt>[:moderator, :attendee]</tt>
  # # password:: Password to be use (in case role == nil)
  # #
  # # Uses the API but does not require a request to the server.
  # def join_url(username, role, password=nil)
    # require_server
# 
    # case role
    # when :moderator
      # self.server.api.join_meeting_url(self.meetingid, username, self.moderator_password)
    # when :attendee
      # self.server.api.join_meeting_url(self.meetingid, username, self.attendee_password)
    # else
      # self.server.api.join_meeting_url(self.meetingid, username, password)
    # end
  # end
# 
# 
  # # Returns the role of the user based on the password given.
  # # The return value can be <tt>:moderator</tt>, <tt>:attendee</tt>, or
  # # nil if the password given does not match any of the room passwords.
  # # params:: Hash with a key :password
  # def user_role(params)
    # role = nil
    # if params.has_key?(:password)
      # if self.moderator_password == params[:password]
        # role = :moderator
      # elsif self.attendee_password == params[:password]
        # role = :attendee
      # end
    # end
    # role
  # end
# 
  # # Compare the instance variables of two models to define if they are equal
  # # Returns a hash with the variables with different values or an empty hash
  # # if they are have all equal values.
  # # From: http://alicebobandmallory.com/articles/2009/11/02/comparing-instance-variables-in-ruby
  # def instance_variables_compare(o)
    # vars = [ :@running, :@participant_count, :@moderator_count, :@attendees,
             # :@has_been_forcibly_ended, :@start_time, :@end_time ]
    # Hash[*vars.map { |v|
           # self.instance_variable_get(v)!=o.instance_variable_get(v) ?
           # [v,o.instance_variable_get(v)] : []}.flatten]
  # end
# 
  # # A more complete equal? method, comparing also the attibutes and
  # # the instance variables
  # def attr_equal?(o)
    # self == o and
      # self.instance_variables_compare(o).empty? and
      # self.attributes == o.attributes
  # end
# 
  # def to_param
    # self.param
  # end
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
  # protected
# 
  # # Every room needs a server to be used.
  # # The server of a room can change during the room's lifespan, but
  # # it should not change if the room is running or if it was created
  # # but not yet ended.
  # # Any action that requires a server should call 'require_server' before
  # # anything else.
  # def require_server
    # if self.server.nil?
      # msg = I18n.t('bigbluebutton_rails.rooms.errors.server.not_set')
      # raise BigbluebuttonRails::ServerRequired.new(msg)
    # end
  # end
# 
  # # This method can be overridden to change the way the server is selected
  # # before a room is created
  # # This one selects the server with less rooms in it
  # def select_server
    # BigbluebuttonServer.
      # select("bigbluebutton_servers.*, count(bigbluebutton_rooms.id) as room_count").
      # joins(:rooms).group(:server_id).order("room_count ASC").first
  # end
# 
   
  # def do_create_meeting
    # msg = (self.welcome_msg.nil? or self.welcome_msg.empty?) ? default_welcome_message : self.welcome_msg
    # opts = {
      # :moderatorPW => self.moderator_password, :attendeePW => self.attendee_password,
      # :welcome => msg, :dialNumber => self.dial_number,
      # :logoutURL => self.full_logout_url || self.logout_url,
      # :maxParticipants => self.max_participants, :voiceBridge => self.voice_bridge
    # }
    # self.server.api.request_headers = @request_headers # we need the client IP
    # self.server.api.create_meeting(self.name, self.meetingid, opts)
  # end
# 
  # # Returns the default welcome message to be shown in a conference in case
  # # there's no message set in this room.
  # # Can be used to easily set a default message format for all rooms.
  # def default_welcome_message
    # I18n.t('bigbluebutton_rails.rooms.default_welcome_msg',
           # :name => self.name, :voice_number => self.voice_bridge)
  # end
# 
  # # if :param wasn't set, sets it as :name downcase and parameterized
  # def set_param
    # if self.param.blank?
      # self.param = self.name.parameterize.downcase unless self.name.nil?
    # end
  # end
# 
# end
end
