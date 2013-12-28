class AccountsController < ApplicationController
  
  before_filter :authenticate_user!
  before_filter :set_user
  
  
  # GET /accounts/1
  # GET /accounts/1.json
  def show
    @account = @user.account 
    authorize! :show, @account
    if @account.nil?
      @account = @user.build_account
      flash[:warning] = t('controller_accounts.no_settings_made_yet')
      redirect_to :action => :new and return
    end
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @account }
    end
  end


  # GET /accounts/1/edit
  def edit
    @account = @user.account
  end
  
  def edit_preferences
    @account = @user.account
  end
  
  def show_preferences
    @account = @user.account
  end

  # POST /accounts
  # POST /accounts.json
  def create
    @account = ProfileSetting.new(params[:account])
    @account.user = @user

    respond_to do |format|
      if @account.save
        format.html { redirect_to user_account_url(:user_id => @account.user) , notice: I18n.t('controller_accounts.account_settings_created', :default => 'Profile setting was successfully created.') }
        format.json { render json: @account, status: :created, location: @account }
      else
        format.html { render action: "new" }
        format.json { render json: @account.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /accounts/1
  # PUT /accounts/1.json
  def update
    @account = @user.account
    logger.debug("Accounts#update - params: #{params.inspect}")
    if params[:from_settings] #&& params[:from_settings] == true
      url = dashboard_settings_url
    else
      url = user_url(:id => @user)
    end
    respond_to do |format|
      if @account.update_attributes(params[:account])
        format.html { redirect_to url, notice: I18n.t('controller_accounts.settings_updated', :default => 'Settings were successfully updated.') }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @account.errors, status: :unprocessable_entity }
      end
    end 
  end
  
  def destroy_portrait
    @user.account.portrait.destroy
    @user.account.save
    if @user.account.portrait.exists?
      logger.error("ProfileSetting#destroy_portrait - could not destroy portrait")
      flash[:error] = "Portrait was not destroyed"
      redirect_to user_account_url(:user_id => @user)
    else
      logger.info("ProfileSetting#destroy_portrait - success")
      redirect_to edit_user_account_url(:user_id => @user), notice: I18n.t('controller_accounts.portrait_destroyed', :default => "Portrait successfully destroyed." )
    end
  end

  
  private
  
  def set_user
    @user = current_or_guest_user #|| User.find(params[:user_id])
  end
end
