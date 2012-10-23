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
      format.html # show.html.erb
    end
  end

  # GET /video_sessions/new
  # GET /video_sessions/new.json
  def new
    
    respond_to do |format|
      format.html # new.html.erb
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
    
    @klu = Klu.find(@video_session.klu_id)
        
    #TODO move to version of update method
    begin
      check_sezzion_create_prerequisites(@klu)  # checks for things that should be in order before creating a sezzion
    rescue KluuuExceptions::KluuuException => e
      logger.error("\n###############\nVideoSession#create - Exception caught - \n#{e.inspect}\n#####################")
      if e.class.superclass.name == 'KluuuExceptions::KluuuExceptionWithRedirect'
        redirect_to e.redirect_link, :alert => e.msg and return
      else
        render e.render_partial, :locals => {:msg => e.msg} and return
      end
    end

    respond_to do |format|
      if @video_session.save
        format.js { render and return }
      else
        format.js { render 'shared/error_flash', :locals => {:msg => t('video_sessions_controller.create.failed_7')} and return }
      end
    end
  end

  # PUT /video_sessions/1
  # PUT /video_sessions/1.json
  def update
    @video_session = VideoSession::Base.find(params[:id])
    
    respond_to do |format|
      begin 
        if @video_session.update_attributes(params[:video_session])
          format.js { redirect_to @video_session }
        else
          format.js { render 'shared/error_flash', :locals => {:msg => t('video_sessions_controller.update.failed_1')} and return }
        end
      rescue KluuuExceptions::KluuuException => e
        logger.error("\n###############\nVideoSession#update - Exception caught - \n#{e.inspect}\n#####################")
        if e.class.superclass.name == 'KluuuExceptions::KluuuExceptionWithRedirect'
          redirect_to e.redirect_link, :alert => e.msg and return
        else
          render e.render_partial, :locals => {:msg => e.msg} and return
        end
      end
    end
  end

  # DELETE /video_sessions/1
  # DELETE /video_sessions/1.json
  def destroy
    @video_session = VideoSession::Base.find(params[:id])
    @video_session.destroy

    respond_to do |format|
      format.html { redirect_to video_sessions_url }
      format.json { head :no_content }
    end
  end
  
  private
  
  def check_sezzion_create_prerequisites(klu)
    #is the klu unpublished or not existing?
    raise KluuuExceptions::KluUnavailableError.new(t('video_sessions_controller.create.failed_1'), 'shared/alert_flash') if (klu.nil? || !klu.published?)
    #is the user trying to call his own klu?
    raise KluuuExceptions::SameUserError.new(t('video_sessions_controller.create.failed_2'), 'shared/alert_flash') if (!current_user.nil?) && (current_user.id == klu.user_id)
    #is the klus user not available?
    raise KluuuExceptions::UserUnavailableError.new(t('video_sessions_controller.create.failed_3'), new_message_path(:receiver_id => klu.user_id)) unless klu.user.available?
    #if a registered user is calling a paid klu then make sure he has money
    raise KluuuExceptions::NoAccountError.new(t('video_sessions_controller.create.failed_4'), new_user_balance_account_path(:user_id => current_user.id)) if (!current_user.nil?) && (klu.charge_type != 'free') && (current_user.balance_account.nil?)
    #if a anonymous user is calling a paid klu
    raise KluuuExceptions::AnonymousUserError.new(t('video_sessions_controller.create.failed_5'), new_user_registration_path()) if current_user.nil? && (klu.charge_type != 'free')
    #make sure the caller has at least credit for one paid minute
    raise KluuuExceptions::NoFundsError.new(t('video_sessions_controller.create.failed_6'), edit_user_balance_account_path(:user_id => current_user.id)) if ((!current_user.nil?) && (klu.charge_type != 'free') && (!current_user.balance_account.check_balance(klu.charge, klu.charge_type, 1)))
  end
end
