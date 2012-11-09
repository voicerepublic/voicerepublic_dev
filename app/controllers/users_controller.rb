class UsersController < ApplicationController
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
    
    respond_to do |format|
      logger.debug("Users#update - params[user]: #{params[:user].inspect}")
      if @user.update_attributes(params[:user])
        format.html { redirect_to  dashboard_settings_url, notice: 'User was successfully updated.' }
        format.json { head :no_content } 
        format.js 
      else
        logger.error("Users#update - ERROR: #{@user.errors.inspect}")
        format.html { render action: "edit" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :no_content }
    end
  end
  
  def online_user
    d = params[:data]
    logger.debug("Users#online_user - #{d.inspect}")
    ret = User.cleanup_online_states
    logger.debug("Users#online_user - cleaned up #{ret} states")
    @users = User.potentially_available
    
    respond_to do |format|
      format.json {  render json: @users }
    end      
  end
end
