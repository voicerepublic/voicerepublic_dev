class CreditAccountsController < ApplicationController
  # GET /credit_accounts
  # GET /credit_accounts.json
  def index
    @credit_accounts = CreditAccount.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @credit_accounts }
    end
  end

  # GET /credit_accounts/1
  # GET /credit_accounts/1.json
  def show
    @credit_account = CreditAccount.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @credit_account }
    end
  end

  # GET /credit_accounts/new
  # GET /credit_accounts/new.json
  def new
    @credit_account = CreditAccount.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @credit_account }
    end
  end

  # GET /credit_accounts/1/edit
  def edit
    @credit_account = CreditAccount.find(params[:id])
  end

  # POST /credit_accounts
  # POST /credit_accounts.json
  def create
    @credit_account = CreditAccount.new(params[:credit_account])

    respond_to do |format|
      if @credit_account.save
        format.html { redirect_to @credit_account, notice: 'Credit account was successfully created.' }
        format.json { render json: @credit_account, status: :created, location: @credit_account }
      else
        format.html { render action: "new" }
        format.json { render json: @credit_account.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /credit_accounts/1
  # PUT /credit_accounts/1.json
  def update
    @credit_account = CreditAccount.find(params[:id])

    respond_to do |format|
      if @credit_account.update_attributes(params[:credit_account])
        format.html { redirect_to @credit_account, notice: 'Credit account was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @credit_account.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /credit_accounts/1
  # DELETE /credit_accounts/1.json
  def destroy
    @credit_account = CreditAccount.find(params[:id])
    @credit_account.destroy

    respond_to do |format|
      format.html { redirect_to credit_accounts_url }
      format.json { head :no_content }
    end
  end
end
