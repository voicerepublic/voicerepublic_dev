require 'video_system_api/video_system_api'

class VideoServer < ActiveRecord::Base
  attr_accessible :activated, :name, :salt, :url, :version
  
  has_many :video_rooms,
           :dependent => :nullify

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

  validates :version,
            :presence => true,
            :inclusion => { :in => ['0.7', '0.8'] }

  # Array of VideoSession in VideoSystem
  attr_reader :video_system_rooms

  after_initialize :init
  
  # Returns the API object associated with this server.
  def api
    if @api.nil?
      @api = VideoSystemApi::VideoSystemApi.new(self.url, self.salt, self.version.to_s, false, 2, Rails.configuration.ip_address)
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
      room = VideoRoom.find_by_server_id_and_meeting_id(self.id, attr[:meetingID])
      if room.nil?
        room = VideoRoom.new(:server => self, :meetingid => attr[:meetingID],
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
