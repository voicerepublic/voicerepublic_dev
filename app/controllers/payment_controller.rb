class PaymentController < ApplicationController
  
  def user_joined
    
    video_room = VideoRoom.find_by_video_system_room_id(params[:meetingId])
    video_session = video_room.video_session
    participant = get_participant(video_session, params)
    timestamp = Time.at(params[:timestamp].to_i)
    
    
    check_prerequisites_user(video_session, video_room, participant, timestamp)
    check_checksum(request.url, video_room.video_server.salt, "user_joined", params[:checksum])
    
    participant.entered_timestamp = timestamp
    
    unless participant.instance_of? Participant::GuestAnonymous
      user = participant.user
      user.update_attribute(:available, 'bizzy')
    end
    
    if participant.save
      @returncode = "SUCCESS"
      dispatch_call_accepted(video_session, participant)
    else
      @returncode = "FAILED"
      @reason = "Unsaved"
      raise 'participant unsaved \n #{participant} \n #{video_session}'
    end
  end
  
  def user_left
    video_room = VideoRoom.find_by_video_system_room_id(params[:meetingId])
    video_session = video_room.video_session
    if video_session.instance_of? VideoSession::Anonymous
      participant = Participant::GuestAnonymous.where('user_cookie_session_id = ? AND video_session_id = ?', params[:user_id], video_session.id).first
      participant ||= Participant::HostRegistered.where('user_id = ? AND video_session_id = ?', params[:user_id], video_session.id).first  
    else 
      participant = Participant::Base.where('user_id = ? AND video_session_id = ?', params[:user_id], video_session.id).first
    end
    timestamp = Time.at(params[:timestamp].to_i)
    
    check_prerequisites_user(video_session, video_room, participant, timestamp)
    check_checksum(request.url, video_room.video_server.salt, "user_left", params[:checksum])
    
    participant.left_timestamp = timestamp
    
    unless participant.instance_of? Participant::GuestAnonymous
      user = participant.user
      user.update_attribute(:available, 'online')
    end
    
    if participant.save
      @returncode = "SUCCESS"
      dispatch_call_ended(video_session, participant)
    else
      @returncode = "FAILED"
      @reason = "Unsaved"
      raise 'participant unsaved \n #{participant} \n #{video_session}'
    end  
  end
  
  def payment_started
  end
  
  def payment_stopped
  end
  
  def meeting_begin
    video_room = VideoRoom.find_by_video_system_room_id(params[:meetingId])
    video_session = video_room.video_session
    timestamp = Time.at(params[:timestamp].to_i)
     
    check_checksum(request.url, video_room.video_server.salt, "meeting_begin", params[:checksum])
    check_prerequisites_meeting(video_session, video_room, timestamp)
    
    if true #video_session.update_attribute(:begin_timestamp, timestamp)
      @returncode = "SUCCESS"
    else
      @returncode = "FAILED"
      @reason = "Unsaved"
      raise 'video session unsaved \n #{video_session} \n #{video_room}'
    end 
  end
  
  def meeting_end
    video_room = VideoRoom.find_by_video_system_room_id(params[:meetingId])
    video_session = video_room.video_session
    timestamp = Time.at(params[:timestamp].to_i)
     
    check_checksum(request.url, video_room.video_server.salt, "meeting_end", params[:checksum])
    check_prerequisites_meeting(video_session, video_room, timestamp)
    
    if true #video_session.update_attribute(:end_timestamp, timestamp)
      @returncode = "SUCCESS"
    else
      @returncode = "FAILED"
      @reason = "Unsaved"
      raise 'video session unsaved \n #{video_session} \n #{video_room}'
    end 
  end
  
  private
  
  def check_prerequisites_user(video_session, video_room, participant, timestamp)
    raise 'Video Session not existing' if video_session == nil
    raise 'Video Room not existing' if video_room == nil
    raise "Participant not existing in Video Session #{video_session.id}" if participant == nil
    raise 'Timestamp invalid' if timestamp == nil
  end
  
  def check_prerequisites_meeting(video_session, video_room, timestamp)
    raise 'Video Session not existing' if video_session == nil
    raise 'Video Room not existing' if video_room == nil
    raise 'Timestamp invalid' if timestamp == nil
  end
  
  def dispatch_call_accepted(video_session, participant)
    if (participant.video_session_role == 'host')
      video_session.create_call_accepted_notification
    end
  end
  
  def dispatch_call_ended(video_session, participant)
    video_session.create_call_ended_notification(participant.video_session_role)
  end
  
  def check_checksum(url, salt, api_call, checksum)
    p = url.gsub(/^.*\?/,"").gsub(/\&checksum=.*$/,"")
    cs = Digest::SHA1.hexdigest(api_call + p + salt)
    raise "Checksum does not match URL:#{url}, PARAMS:#{p}, FROM VideoSystem:#{checksum}, CALCULATED:#{cs}" if cs != checksum
  end
  
  def get_participant(video_session, params)
    if video_session.instance_of? VideoSession::Anonymous
      participant = Participant::GuestAnonymous.where('user_cookie_session_id = ? AND video_session_id = ?', params[:user_id], video_session.id).first
      participant ||= Participant::HostRegistered.where('user_id = ? AND video_session_id = ?', params[:user_id], video_session.id).first  
    else 
      participant = Participant::Base.where('user_id = ? AND video_session_id = ?', params[:user_id], video_session.id).first
    end
    
    participant
  end
end
