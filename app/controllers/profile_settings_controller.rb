class ProfileSettingsController < ApplicationController
  
  before_filter :set_user
  

  # GET /profile_settings/1
  # GET /profile_settings/1.json
  def show
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


  # GET /profile_settings/1/edit
  def edit
    #@profile_setting = ProfileSetting.find(params[:id])
    @profile_setting = @user.profile_setting
  end

  # POST /profile_settings
  # POST /profile_settings.json
  def create
    @profile_setting = ProfileSetting.new(params[:profile_setting])
    @profile_setting.user = @user

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
    @user.profile_setting.portrait.destroy
    #@user.profile_setting.portrait = nil
    if @user.profile_setting.portrait.exists?
      logger.error("ProfileSetting#destroy_portrait - could not destroy portrait")
      flash[:error] = "Portrait was not destroyed"
      redirect_to user_profile_setting_url(:user_id => @user)
    else
      logger.info("ProfileSetting#destroy_portrait - success")
      redirect_to user_profile_setting_url(:user_id => @user), notice: "Portrait successfully destroyed." 
    end
  end

  
  private
  
  def set_user
    @user = current_user || User.find(params[:user_id])
  end
end
