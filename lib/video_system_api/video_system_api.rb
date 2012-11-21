require 'net/http'
require 'cgi'
require 'rexml/document'
require 'digest/sha1'
require 'rubygems'
require 'nokogiri'

module VideoSystemApi

  # This class provides access to the Video System API. The Video System is derived from 
  # BigBlueButton and this is an open source project that provides web conferencing for distance
  # education (http://code.google.com/p/bigbluebutton/wiki/API). This API
  # was developed to support the following version of BBB: 0.7, 0.8 (soon)
  #
  # Sample usage of the API is as follows:
  # 1) Create a meeting with the create_meeting call
  # 2) Direct a user to either join_meeting_url
  # 3) To force meeting to end, call end_meeting
  #
  #
  # this version:
  # Author::    Martin Unger  (mailto:unger@basisklasse.de)
  # Copyright:: Copyright (c) 2012 Martin Unger
  # Project::   KluuU.com - share your voice
  # License::   Distributes under same terms as Ruby
  #
  # 0.0.4+:
  # Author::    Leonardo Crauss Daronco  (mailto:leonardodaronco@gmail.com)
  # Copyright:: Copyright (c) 2011 Leonardo Crauss Daronco
  # Project::   GT-Mconf: Multiconference system for interoperable web and mobile @ PRAV Labs - UFRGS
  # License::   Distributes under same terms as Ruby
  #
  # 0.0.3 and below:
  # Author::    Joe Kinsella  (mailto:joe.kinsella@gmail.com)
  # Copyright:: Copyright (c) 2010 Joe Kinsella
  # License::   Distributes under same terms as Ruby
  #
  # Considerations about the returning hash:
  # * The XML returned by the Video System is converted to a Hash. See the desired method's documentation for examples.
  # * Three values will *always* exist in the hash: :returncode (boolean), :messageKey (string) and :message (string)
  # * Some of the values returned by Video System are converted to better represent the data. Some of these are listed
  #   bellow. They will *always* have the type informed:
  #   * :meetingID (string)
  #   * :attendeePW (string)
  #   * :moderatorPW (string)
  #   * :running (boolean)
  #   * :hasBeenForciblyEnded (boolean)
  #   * :endTime and :startTime (DateTime or nil)
  #
  class VideoSystemApi

    attr_accessor :url, :supported_versions, :salt, :version, :debug, :timeout, :ip, :port

    # Initializes an instance
    # url::       URL to a BigBlueButton server (e.g. http://demo.bigbluebutton.org/bigbluebutton/api)
    # salt::      Secret salt for this server
    # version::   API version: 0.7 (valid for 0.7, 0.71 and 0.71a but also running with 0.8 servers)
    def initialize(url, salt, debug=false, timeout=2, ip='127.0.0.1', port='3000', version='0.7')
      @supported_versions = ['0.7']
      @port = port
      @ip = ip
      @url = url
      @salt = salt
      @debug = debug
      @timeout = timeout # 2 seconds timeout for get requests
      
      @version = version || get_api_version
      unless @supported_versions.include?(@version)
        raise VideoSystemApiException.new("VideoSystemApi error: Invalid API version #{version}. Supported versions: #{@supported_versions.join(', ')}")
      end

      puts "VideoSystemApi: Using version #{@version}" if @debug
    end
    
    # Returns the url used to join the meeting
    # meeting_id::        Unique identifier for the meeting
    # user_name::         Name of the user
    # password::          Password for this meeting - used to set the user as moderator or attendee
    # user_id::           Unique identifier for this user
    def join_meeting_url(meeting_id, user_name, password,
                         user_id = nil)

      params = { :meetingID => meeting_id, :password => password, :fullName => user_name,
                 :userID => user_id}
      get_url(:join, params)
    end

    # Creates a new meeting. Returns the hash with the response or
    # throws VideoSystemApiException on failure.
    # meeting_name::        Name for the meeting
    # meeting_id::          Unique identifier for the meeting
    # moderator_password::  Moderator password
    # attendee_password::   Attendee password
    # welcome_message::     Welcome message to display in chat window
    # dialin_number::       Dial in number for conference using a regular phone
    # logout_url::          URL to return user to after exiting meeting
    # voice_bridge::        Voice conference number
    #
    # === Return examples (for 0.7)
    #
    # On successful creation:
    #
    #   {
    #    :returncode=>true, :meetingID=>"bigbluebutton-api-ruby-test",
    #    :attendeePW=>"1234", :moderatorPW=>"4321", :hasBeenForciblyEnded=>false,
    #    :messageKey=>"", :message=>""
    #   }
    #
    # Meeting that was forcibly ended:
    #
    #   {
    #    :returncode=>true, :meetingID=>"bigbluebutton-api-ruby-test",
    #    :attendeePW=>"1234", :moderatorPW=>"4321", :hasBeenForciblyEnded=>true,
    #    :messageKey=>"duplicateWarning",
    #    :message=>"This conference was already in existence and may currently be in progress."
    #   }
    #
    def create_meeting(meeting_name, meeting_id, welcome_message = nil, 
                       tt = nil, ttp = nil, charge_cents = nil, currency = nil, 
                       dial_number = nil, logout_url = '#',
                       max_participants = 2, voice_bridge = 72879,
                       moderator_password = nil, attendee_password = nil)

      params = { :name => meeting_name, :meetingID => meeting_id,
                 :moderatorPW => moderator_password, :attendeePW => attendee_password,
                 :welcome => welcome_message, :dialNumber => dial_number,
                 :logoutURL => logout_url, :maxParticpants => max_participants,
                 :voiceBridge => voice_bridge, :kluuuIp => @ip, :kluuuPort => @port, 
                 :tt => tt, :ttp => ttp, :charge => charge_cents, :currency => currency }

      response = send_api_request(:create, params)

      formatter = VideoSystemApiFormatter.new(response)
      formatter.to_string(:meetingID)
      formatter.to_string(:moderatorPW)
      formatter.to_string(:attendeePW)
      formatter.to_boolean(:hasBeenForciblyEnded)
     
      puts "VideoSystemApi:create_meeting:RESPONSE:after_format:#{response}" if @debug
      response
    end

    # Ends an existing meeting. Throws VideoSystemApiException on failure.
    # meeting_id::          Unique identifier for the meeting
    # moderator_password::  Moderator password
    #
    # === Return examples (for 0.7)
    #
    # On success:
    #
    #   {
    #    :returncode=>true, :messageKey=>"sentEndMeetingRequest",
    #    :message=>"A request to end the meeting was sent.  Please wait a few seconds, and then use the getMeetingInfo
    #               or isMeetingRunning API calls to verify that it was ended."
    #   }
    #
    def end_meeting(meeting_id, moderator_password)
      send_api_request(:end, { :meetingID => meeting_id, :password => moderator_password } )
    end

    # Returns true or false as to whether meeting is open.  A meeting is
    # only open after at least one participant has joined.
    # meeting_id::          Unique identifier for the meeting
    def is_meeting_running?(meeting_id)
      hash = send_api_request(:isMeetingRunning, { :meetingID => meeting_id } )
      VideoSystemApiFormatter.new(hash).to_boolean(:running)
    end

    # Returns a hash object containing the meeting information.
    # See the API documentation for details on the return XML
    # (http://code.google.com/p/bigbluebutton/wiki/API).
    #
    # meeting_id::  Unique identifier for the meeting
    # password::    Moderator password for this meeting
    #
    # === Return examples (for 0.7)
    #
    # With attendees:
    #
    #   {
    #    :returncode=>true, :meetingID=>"bigbluebutton-api-ruby-test", :attendeePW=>"1234", :moderatorPW=>"4321", :running=>true,
    #    :hasBeenForciblyEnded=>false, :startTime=>DateTime("Wed Apr 06 17:09:57 UTC 2011"), :endTime=>nil, :participantCount=>4, :moderatorCount=>2,
    #    :attendees => [
    #      {:userID=>"ndw1fnaev0rj", :fullName=>"House M.D.", :role=>:moderator},
    #      {:userID=>"gn9e22b7ynna", :fullName=>"Dexter Morgan", :role=>:moderator},
    #      {:userID=>"llzihbndryc3", :fullName=>"Cameron Palmer", :role=>:viewer},
    #      {:userID=>"rbepbovolsxt", :fullName=>"Trinity", :role=>:viewer}
    #    ], :messageKey=>"", :message=>""
    #   }
    #
    # Without attendees (not started):
    #
    #   {
    #    :returncode=>true, :meetingID=>"bigbluebutton-api-ruby-test", :attendeePW=>"1234", :moderatorPW=>"4321", :running=>false,
    #    :hasBeenForciblyEnded=>false, :startTime=>nil, :endTime=>nil, :participantCount=>0, :moderatorCount=>0,
    #    :attendees=>[], :messageKey=>"", :message=>""
    #   }
    #
    def get_meeting_info(meeting_id, password)
      response = send_api_request(:getMeetingInfo, { :meetingID => meeting_id, :password => password } )

      formatter = VideoSystemApiFormatter.new(response)
      formatter.flatten_objects(:attendees, :attendee)
      response[:attendees].each { |a| formatter.format_attendee(a) }

      formatter.to_string(:meetingID)
      formatter.to_string(:moderatorPW)
      formatter.to_string(:attendeePW)
      formatter.to_boolean(:hasBeenForciblyEnded)
      formatter.to_boolean(:running)
      formatter.to_datetime(:startTime)
      formatter.to_datetime(:endTime)

      response
    end

    # Returns a hash object containing information about the meetings currently existent in the Video System
    # server, either they are running or not.
    #
    # === Return examples (for 0.7)
    #
    # Server with one or more meetings:
    #
    #   { :returncode => true,
    #     :meetings => [
    #       {:meetingID=>"Demo Meeting", :attendeePW=>"ap", :moderatorPW=>"mp", :hasBeenForciblyEnded=>false, :running=>true},
    #       {:meetingID=>"I was ended Meeting", :attendeePW=>"pass", :moderatorPW=>"pass", :hasBeenForciblyEnded=>true, :running=>false}
    #     ],
    #    :messageKey=>"", :message=>""
    #   }
    #
    # Server with no meetings:
    #
    #   {:returncode=>true, :meetings=>[], :messageKey=>"noMeetings", :message=>"no meetings were found on this server"}
    #
    def get_meetings
      response = send_api_request(:getMeetings, { :random => rand(9999999999) } )

      formatter = VideoSystemApiFormatter.new(response)
      formatter.flatten_objects(:meetings, :meeting)
      response[:meetings].each { |m| formatter.format_meeting(m) }
      response
    end

    # Returns the API version (as string) of the associated server. This actually returns
    # the version returned by the BBB server, and not the version set by the user in
    # the initialization of this object.
    def get_api_version
      response = send_api_request(:index)
      response[:returncode] ? response[:version].to_s : ""
    end

    # Make a simple request to the server to test the connection
    def test_connection
      response = send_api_request(:index)
      response[:returncode]
    end

    # API's are equal if all the following attributes are equal
    def ==(other)
      r = true
      [:url, :supported_versions, :salt, :version, :debug].each do |param|
        r = r && self.send(param) == other.send(param)
      end
      r
    end

    def last_http_response
      @http_response
    end

    def get_url(method, data={})
      if method == :index
        return @url
      end

      url = "#{@url}/#{method}?"

      # stringify and escape all params
      data.delete_if { |k, v| v.nil? } unless data.nil?
      params = ""
      params = data.map{ |k,v| "#{k}=" + CGI::escape(v.to_s) unless k.nil? || v.nil? }.join("&")

      # checksum calc
      checksum_param = params + @salt
      checksum_param = method.to_s + checksum_param
      checksum = Digest::SHA1.hexdigest(checksum_param)

      # final url
      url += "#{params}&" unless params.empty?
      url += "checksum=#{checksum}"
    end

    def send_api_request(method, data = {})
      url = get_url(method, data)
     
      @http_response = send_request(url)
      return { } if @http_response.body.empty?

      # 'Hashify' the XML
      hash = Hash.from_xml(@http_response.body)

      # simple validation of the xml body
      unless hash.has_key?(:response) and hash[:response].has_key?(:returncode)
        raise VideoSystemApiException.new("Invalid response body. Is the API URL correct? \"#{@url}\", version #{@version}")
      end

      # default cleanup in the response
      hash = VideoSystemApiFormatter.new(hash).default_formatting

      # all responses should have a returncode
      unless hash[:returncode]
        exception = VideoSystemApiException.new(hash[:message])
        exception.key = hash.has_key?(:messageKey) ? hash[:messageKey] : ""
        raise exception
      end

      hash
    end

    protected

    def send_request(url)
      begin
        puts "VideoSystemAPI DEBUG: URL request = #{url}" if @debug
        url_parsed = URI.parse(url)
        http = Net::HTTP.new(url_parsed.host, url_parsed.port)
        http.open_timeout = @timeout
        http.read_timeout = @timeout
        response = http.get(url_parsed.request_uri)
        puts "VideoSystemAPI DEBUG: URL response = #{response.body}" if @debug
      rescue TimeoutError => error
        raise VideoSystemApiException.new("Timeout error. Your server is probably down: \"#{@url}\"")
      rescue Exception => error
        raise VideoSystemApiException.new("Connection error. Your URL is probably incorrect: \"#{@url}\"")
      end
      response
    end

  end
end


