require 'kluuu_exceptions'

class VideoSessionsController < ApplicationController
  # GET /video_sessions
  # GET /video_sessions.json
  def index
    @video_sessions = VideoSession::Base.all

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET /video_sessions/1
  # GET /video_sessions/1.json
  def show
    @video_session = VideoSession::Base.find(params[:id])
    @user = guest_or_current_user 
    
    if @user.nil? 
      @participant = Participant::GuestAnonymous.where('user_cookie_session_id = ? AND video_session_id = ?', session[:session_id], @video_session.id).first
    else 
      @participant = Participant::Base.where('user_id = ? AND video_session_id = ?', @user.id, @video_session.id).first
    end   
    
    logger.info("VideoSessions#show - STEP 3  - show video_session: #{@video_session.id}")
    
    @klu = @video_session.klu

    respond_to do |format|
     
      format.js # show.html.erb
    end
  end

  # GET /video_sessions/new
  # GET /video_sessions/new.json
  def new
    
    @klu = Klu.find(params[:klu_id]) unless params[:klu_id].nil?
    
    respond_to do |format|
      format.js # new.js.erb
    end
  end

  # POST /video_sessions
  # POST /video_sessions.json
  def create
    if params[:video_session][:type] == 'VideoSession::Registered'
      @video_session = VideoSession::Registered.new(params[:video_session])
    else
      @video_session = VideoSession::Anonymous.new(params[:video_session])
    end 
    
    respond_to do |format|
      begin
        if @video_session.save
          logger.info("VideoSessions#create - STEP 1 CALLING - saved new video_session: #{@video_session.id}")
          format.js { render and return }
        else
          format.js { render 'shared/error_flash', :locals => {:msg => t('video_sessions_controller.create.failed_7')} and return }
        end
      rescue KluuuExceptions::KluuuException => e
        logger.error("\n###############\nVideoSession#create - Exception caught - \n#{e.inspect}\n#####################")
        if e.class.superclass.name == 'KluuuExceptions::KluuuExceptionWithRedirect'
          redirect_to e.redirect_link, :alert => e.msg and return
        else
          format.js { render e.render_partial, :locals => e.locals and return }
        end
      end
    end
  end

  # PUT /video_sessions/1
  # PUT /video_sessions/1.json
  def update
    @video_session = VideoSession::Base.find(params[:id])
    
    respond_to do |format|
      begin 
        logger.warn("VideoSession#update - debug:  #{@video_session.inspect} \n valid? #{@video_session.valid?} \n errors: #{@video_session.errors.inspect}")
        if @video_session.save
          logger.info("VideoSessions#update - STEP 2 ACCEPTING - updated video_session: #{@video_session.id}")
          format.js { redirect_to video_session_path(:id => @video_session.id) and return }
        else
          logger.error("VideoSession#update - error saving video-session: #{@video_session.inspect}")
          format.js { render 'shared/error_flash', :locals => {:msg => t('video_sessions_controller.update.failed_1')} and return }
        end
      rescue KluuuExceptions::KluuuException => e
        logger.error("\nVideoSession#update - ERROR Exception caught - \n#{e.inspect}\n")
        if e.class.superclass.name == 'KluuuExceptions::KluuuExceptionWithRedirect'
          redirect_to e.redirect_link, :alert => e.msg and return
        elsif e.class.name == 'KluuuExceptions::VideoSystemError'
          @video_session.create_room_creation_failed_notification
          render e.render_partial, :locals => {:msg => e.msg} and return
        else
          render e.render_partial, :locals => {:msg => e.msg} and return
        end
      end
    end
  end

  # DELETE /video_sessions/1
  # DELETE /video_sessions/1.json
  def destroy
    logger.info("VideoSession#destroy - params: #{params.inspect}")
    @video_session = VideoSession::Base.find(params[:id])
    @video_session.canceling_participant_id = params[:canceling_participant_id]
    @video_session.destroy

    respond_to do |format|
      @msg = t('.call_ended', :default => 'call ended') 
      format.js {}
    end
  end
  
  def video_session_config
    room = VideoRoom.find_by_video_system_room_id(params[:meeting_id])
    video_session = room.video_session
    
    begin
      user = User.find(params[:user_id])
      participant = Participant::Base.where('user_id = ? AND video_session_id = ?', user.id, video_session.id).first
    rescue
      participant = Participant::GuestAnonymous.where('user_cookie_session_id = ? AND video_session_id = ?', session[:session_id], video_session.id).first
    end
    
    if participant.nil? || video_session.nil? || room.nil?
      logger.error("\n###############\nVideoSession#video_session_config \n Participant #{participant.inspect} \n Video Session #{video_session.inspect} \n Room #{room.inspect} \n#####################")
    end 
    
    #TODO: equality of @user.id and participant.user_id to make sure there is no tampering going on
    
    if ((video_session.klu.get_charge_type_as_integer != 1)) #&& (participant.instance_of? Participant::GuestRegistered))
      @time_to_pay = Payment::Calculation.free_time(video_session, participant)
      @credit = KluuuCode::Helper.dollarize(((participant.user.balance_account.balance + participant.user.balance_account.revenue).exchange_to(video_session.klu.currency)).cents)
    else
      @credit = -1
      @time_to_pay = -1
    end
    
    @video_server_address = room.video_server.url.gsub("http:\/\/","").gsub(/\/.*/,"")
  end
 
end
