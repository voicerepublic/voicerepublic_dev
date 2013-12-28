class Balance::AccountsController < ApplicationController
  
  layout 'dashboard'
  
  before_filter :authenticate_user!
  before_filter :set_user
  
  # GET /balance/accounts
  # GET /balance/accounts.json
  def index
    @balance_account = @user.balance_account

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @balance_accounts }
    end
  end

  # GET /balance/accounts/1
  # GET /balance/accounts/1.json
  def show
    @balance_account = @user.balance_account

    redirect_to :action => :new and return if @balance_account.nil?
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @balance_account }
    end
  end

  # GET /balance/accounts/new
  # GET /balance/accounts/new.json
  def new
    redirect_to dashboard_url, :notice => "weired thing happened..." and return unless  @user.balance_account.nil?
    @balance_account = @user.build_balance_account

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @balance_account }
    end
  end

  # GET /balance/accounts/1/edit
  def edit
    @balance_account = Balance::Account.find(params[:id])
  end

  # POST /balance/accounts
  # POST /balance/accounts.json
  def create
    redirect_to dashboard_url, :notice => "weired thing happened..." and return unless  @user.balance_account.nil?
    @balance_account = Balance::Account.new(params[:balance_account].merge(:user_id => @user.id))

    respond_to do |format|
      if @balance_account.save
        format.html { redirect_to user_balance_account_path(:user_id => @user), notice: 'Account was successfully created.' }
        format.json { render json: @balance_account, status: :created, location: @balance_account }
      else
        logger.error("Balance::Accounts#create - ERROR #{@balance_account.errors.inspect}")
        format.html { render action: "new" }
        format.json { render json: @balance_account.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /balance/accounts/1
  # PUT /balance/accounts/1.json
  def update
    @balance_account = Balance::Account.find(params[:id])

    respond_to do |format|
      if @balance_account.update_attributes(params[:balance_account])
        format.html { redirect_to @balance_account, notice: 'Account was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @balance_account.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /balance/accounts/1
  # DELETE /balance/accounts/1.json
  def destroy
    @balance_account = Balance::Account.find(params[:id])
    @balance_account.destroy

    respond_to do |format|
      format.html { redirect_to balance_accounts_url }
      format.json { head :no_content }
    end
  end
  
  private
  
  def set_user
    @user = @user || current_or_guest_user
  end
end
