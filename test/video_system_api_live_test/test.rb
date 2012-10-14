$:.unshift File.expand_path(File.dirname(__FILE__))
$:.unshift File.join(File.expand_path(File.dirname(__FILE__)), '..', 'lib')

require 'video_system_api'
require 'thread'
require 'yaml'

def prepare

  config_file = File.join(File.dirname(__FILE__), 'config.yml')
  unless File.exist? config_file
    puts config_file + " does not exists. Copy the example and configure your server."
    puts "cp test/config.yml.example test/config.yml"
    puts
    Kernel.exit!
  end
  @config = YAML.load_file(config_file)

  puts "config:"
  @config.each do |k,v|
    puts k + ": " + v
  end

  @api = VideoSystemApi::VideoSystemApi.new(@config['bbb_url'], @config['bbb_salt'], @config['bbb_version'].to_s, true)

end

def general_test

  puts
  puts "---------------------------------------------------"
  if @api.test_connection
    puts "Connection successful! continuing..."
  else
    puts "Connection failed! The server might be unreachable. Exiting..."
    Kernel.exit!
  end

  puts
  puts "---------------------------------------------------"
  version = @api.get_api_version
  puts "The API version of your server is #{version}"

  puts
  puts "---------------------------------------------------"
  response = @api.get_meetings
  puts "Existent meetings in your server:"
  response[:meetings].each do |m|
    puts "  " + m[:meetingID] + ": " + m.inspect
  end

  puts
  puts "---------------------------------------------------"
  @api.create_meeting(@config['meeting_name'], @config['meeting_id'], @config['moderator_password'], @config['attendee_password'],
                     'Welcome to my meeting', '1-800-000-0000x00000#', 'https://github.com/mconf/bigbluebutton-api-ruby', 10)
  puts "The meeting has been created. Please open a web browser and enter the meeting using either of the URLs below."

  puts
  puts "---------------------------------------------------"
  url = @api.join_meeting_url(@config['meeting_id'], @config['moderator_name'], @config['moderator_password'])
  puts "1) Moderator URL = #{url}"
  puts ""
  url = @api.join_meeting_url(@config['meeting_id'], @config['attendee_name'], @config['attendee_password'])
  puts "2) Attendee URL = #{url}"

  puts
  puts "---------------------------------------------------"
  puts "Waiting 30 seconds for you to enter via browser"
  sleep(30)

  unless @api.is_meeting_running?(@config['meeting_id'])
    puts "You have NOT entered the meeting"
    Kernel.exit!
  end
  puts "You have successfully entered the meeting"

  puts
  puts "---------------------------------------------------"
  response = @api.get_meeting_info(@config['meeting_id'], @config['moderator_password'])
  puts "Meeting info:"
  puts response.inspect

  puts
  puts "---------------------------------------------------"
  puts "Attendees:"
  response[:attendees].each do |m|
    puts "  " + m[:fullName] + " (" +  m[:userID] + "): " + m.inspect
  end


  puts
  puts "---------------------------------------------------"
  @api.end_meeting(@config['meeting_id'], @config['moderator_password'])
  puts "The meeting has been ended"

rescue Exception => ex
  puts "Failed with error #{ex.message}"
  puts ex.backtrace

end

def join_test
  unless @api.is_meeting_running?(@config['meeting_id'])
    @api.create_meeting(@config['meeting_name'], @config['meeting_id'], @config['moderator_password'], @config['attendee_password'],
                       'Welcome to my meeting', '1-800-000-0000x00000#', 'https://github.com/mconf/bigbluebutton-api-ruby', 10)
    puts "The meeting has been created. Please open a web browser and enter the meeting as moderator."

    puts
    puts "---------------------------------------------------"
    url = @api.join_meeting_url(@config['meeting_id'], @config['moderator_name'], @config['moderator_password'])
    puts "1) Moderator URL = #{url}"

    puts
    puts "---------------------------------------------------"
    puts "Waiting 30 seconds for you to enter via browser"
    sleep(30)
  end

  unless @api.is_meeting_running?(@config['meeting_id'])
    puts "You have NOT entered the meeting"
    Kernel.exit!
  end
  puts "You have successfully entered the meeting"

  puts
  puts "---------------------------------------------------"
  response = @api.get_meeting_info(@config['meeting_id'], @config['moderator_password'])
  puts "Meeting info:"
  puts response.inspect

  puts
  puts
  puts
  puts "---------------------------------------------------"
  response = @api.join_meeting(@config['meeting_id'], @config['attendee_name'], @config['attendee_password'])
  puts "Join meeting response:"
  puts response.inspect

end

def get_version_test
  @api = VideoSystemApi::VideoSystemApi.new(@config['bbb_url'], @config['bbb_salt'], nil, true)

  puts
  puts "---------------------------------------------------"
  puts "The version of your BBB server is: #{@api.version}"
end

begin
  prepare
  general_test
  #join_test
  #get_version_test
end
