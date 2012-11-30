require 'video_system_api/video_system_api'

class VideoServer < ActiveRecord::Base
  attr_accessible :activated, :name, :salt, :url
  
  has_many :video_rooms, :class_name => 'VideoRoom', :foreign_key => 'video_server_id', :dependent => :nullify

  validates :name,
            :presence => true,
            :uniqueness => true,
            :length => { :minimum => 1, :maximum => 500 }

  validates :url,
            :presence => true,
            :uniqueness => true,
            :length => { :maximum => 500 },
            :format => { :with => /http:\/\/.*\/bigbluebutton\/api/,
                         :message => I18n.t('video_system.servers.errors.url_format') }

  validates :salt,
            :presence => true,
            :length => { :minimum => 1, :maximum => 500 }


  # Array of VideoSession in VideoSystem
  attr_reader :video_system_rooms
  
  scope :activated, where('activated=?', true)

  after_initialize :init
  
  # Returns the API object associated with this server.
  def api
    if @api.nil?
      @api = VideoSystemApi::VideoSystemApi.new(self.url, self.salt, false, 2, Rails.configuration.ip_address, Rails.configuration.ip_port)
    end
    @api
  end

  # Fetches the meetings currently created in the server (running or not).
  #
  # Using the response, updates <tt>VideoSessions</tt> with a list of <tt>VideoRoom</tt>
  # objects.
  #
  # Triggers API call: <tt>get_meetings</tt>.
  def fetch_video_system_rooms
    response = self.api.get_meetings

    # updates the Information of the Rooms that are currently registered on this Video Server
    @video_system_rooms = []
    response[:meetings].each do |attr|
      room = VideoRoom.find_by_video_server_id_and_video_system_room_id(self.id, attr[:meetingID])
      if room.nil?
        room = VideoRoom.new(:video_server_id => self.id, :video_system_room_id => attr[:meetingID],
                             :name => attr[:meetingID], :guest_password => attr[:attendeePW],
                             :host_password => attr[:moderatorPW])
      else
        room.update_attributes(:guest_password => attr[:attendeePW],
                               :host_password => attr[:moderatorPW])
      end
      room.running = attr[:running]

      @video_system_rooms << room
    end
  end

  protected

  def init
    # fetched attributes
    @video_system_rooms = []
  end  
end
