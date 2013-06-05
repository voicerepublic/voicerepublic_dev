class UsersController < ApplicationController
  
  before_filter :authenticate_user!, :only => [:edit,:update,:destroy]
  
  layout "application", :only => [:welcome]
  
  # GET /users
  # GET /users.json
  def index
    @users = User.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @users }
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @user = User.find(params[:id])
    @kluuus = @user.kluuus

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user }
    end
  end

  def no_kluuus
    @user = User.find(params[:id])
    @kluuus = @user.no_kluuus
    render :template =>  'users/kluuus'
  end

  def kluuus
    @user = User.find(params[:id])
    @kluuus = @user.kluuus
  end
  
  def venues
    @user = User.find(params[:id])
    @venues = Venue.of_user(@user)
    
  end

  # GET /users/new
  # GET /users/new.json
  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
    authorize! :edit, @user
    #render :layout => 'application'
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(params[:user])

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render json: @user, status: :created, location: @user }
      else
        format.html { render action: "new" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.json
  def update
    @user = User.find(params[:id])
    @account = @user.account
    authorize! :update, @user
    
    respond_to do |format|
      logger.debug("Users#update - params[user]: #{params[:user].inspect}")
      url = if params[:from_settings]
              dashboard_settings_url
            elsif params[:from_account]
              @account = @user.account
              user_url(:id => @user )
            else
              user_url(:id => @user)
            end
      if @user.update_attributes(params[:user])
        format.html { redirect_to  url, notice: 'User was successfully updated.' }
        format.json { head :no_content }
        format.js
      else
        logger.error("Users#update - ERROR: #{@user.errors.inspect}")
        format.html do
            if params[:from_account]
              render :template => 'accounts/edit', :layout => 'application'
            elsif params[:from_settings]
              render(:template => 'dashboard/edit_settings', :layout => 'dashboard')
            else
              render :action => :edit
            end
         end
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user = User.find(params[:id])
    
    authorize! :destroy, @user
    
    @user.destroy

    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :no_content }
    end
  end

  # called via JQuery.ajax call var checkUserOnline
  # defined in application.js
  #
  def status_for
    ret = User.cleanup_online_states
    logger.debug("Users#status_for - cleaned up #{ret.inspect} states")
    logger.debug("Users#status_for - params: #{params.inspect}")
    if params[:ids] && params[:ids].length > 0
      @users = User.online_status_for_ids( params[:ids].split(",").collect )
    else
      @users = []
    end
    respond_to do |format|
      format.json { render json: @users  }
    end
  end

  # NOT used anymore
  def online_user
    logger.debug("Users#online_user - #{params.inspect}")
    d = params[:ids].split(",").collect
    ret = User.cleanup_online_states
    logger.debug("Users#online_user - cleaned up #{ret} states")
    @users = User.potentially_available
    respond_to do |format|
      format.json {  render json: @users }
    end
  end
  
  def welcome
    @klu = current_user.no_kluuus.build(:tag_list => "newcomer")
    @user = current_user
  end
end
