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
    
    begin
      respond_to do |format|
        if @video_session.save
          format.js { render and return }
        else
          format.js { render 'shared/error_flash', :locals => {:msg => t('video_sessions_controller.create.failed_7')} and return }
        end
      end
    rescue KluuuExceptions::KluuuException => e
      logger.error("\n###############\nVideoSession#create - Exception caught - \n#{e.inspect}\n#####################")
      if e.class.superclass.name == 'KluuuExceptions::KluuuExceptionWithRedirect'
        redirect_to e.redirect_link, :alert => e.msg and return
      else
        render e.render_partial, :locals => {:msg => e.msg} and return
      end
    end

  end

  # PUT /video_sessions/1
  # PUT /video_sessions/1.json
  def update
    @video_session = VideoSession::Base.find(params[:id])
    
    respond_to do |format|
      #begin 
        if @video_session.update_attributes(params[:video_session])
          format.js { render and return }
        else
          format.js { render 'shared/error_flash', :locals => {:msg => t('video_sessions_controller.update.failed_1')} and return }
        end
      #rescue KluuuExceptions::KluuuException => e
      #  logger.error("\n###############\nVideoSession#update - Exception caught - \n#{e.inspect}\n#####################")
      #  if e.class.superclass.name == 'KluuuExceptions::KluuuExceptionWithRedirect'
      #    redirect_to e.redirect_link, :alert => e.msg and return
      #  else
      #    render e.render_partial, :locals => {:msg => e.msg} and return
      #  end
      #end
    end
  end

  # DELETE /video_sessions/1
  # DELETE /video_sessions/1.json
  def destroy
    @video_session = VideoSession::Base.find(params[:id])
    @video_session.canceling_participant_id = params[:canceling_participant_id]
    @video_session.destroy

    respond_to do |format|
      @msg = t('.call_ended', :default => 'call ended') 
      format.js { render 'shared/notice_flash' }
    end
  end
end
