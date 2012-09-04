class ProfileSettingsController < ApplicationController
  # GET /profile_settings
  # GET /profile_settings.json
  def index
    @profile_settings = ProfileSetting.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @profile_settings }
    end
  end

  # GET /profile_settings/1
  # GET /profile_settings/1.json
  def show
    @user = User.find(params[:user_id])
    @profile_setting = @user.profile_setting 
    if @profile_setting.nil?
      @profile_setting = @user.build_profile_setting
      flash[:warning] = t('.settings_controller.no_settings_made_yet')
      redirect_to :action => :new and return
    end
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @profile_setting }
    end
  end

  # GET /profile_settings/new
  # GET /profile_settings/new.json
  def new
    @profile_setting = ProfileSetting.new
    @user = current_user
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @profile_setting }
    end
  end

  # GET /profile_settings/1/edit
  def edit
    #@profile_setting = ProfileSetting.find(params[:id])
    @user = User.find(params[:user_id])
    @profile_setting = @user.profile_setting
  end

  # POST /profile_settings
  # POST /profile_settings.json
  def create
    @profile_setting = ProfileSetting.new(params[:profile_setting])
    @profile_setting.user = current_user

    respond_to do |format|
      if @profile_setting.save
        format.html { redirect_to user_profile_setting_url(:user_id => @profile_setting.user) , notice: 'Profile setting was successfully created.' }
        format.json { render json: @profile_setting, status: :created, location: @profile_setting }
      else
        format.html { render action: "new" }
        format.json { render json: @profile_setting.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /profile_settings/1
  # PUT /profile_settings/1.json
  def update
    @user = User.find(params[:user_id])
    @profile_setting = @user.profile_setting

    respond_to do |format|
      if @profile_setting.update_attributes(params[:profile_setting])
        format.html { redirect_to user_profile_setting_url(:user_id => @user), notice: 'Profile setting was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @profile_setting.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def destroy_portrait
    @user = User.find(params[:user_id])
    @user.profile_setting.portrait.destroy
    #@user.profile_setting.portrait = nil
    if @user.profile_setting.portrait.exists?
      flash[:error] = "Portrait was not destroyed"
      redirect_to user_profile_setting_url(:user_id => @user)
    else
      redirect_to user_profile_setting_url(:user_id => @user), notice: "Portrait successfully destroyed." 
    end
  end

  # DELETE /profile_settings/1
  # DELETE /profile_settings/1.json
  #def destroy
  #  @profile_setting = ProfileSetting.find(params[:id])
  #  @profile_setting.destroy#
  #
  #  respond_to do |format|
  #    format.html { redirect_to profile_settings_url }
  #    format.json { head :no_content }
  #  end
  #end
end
