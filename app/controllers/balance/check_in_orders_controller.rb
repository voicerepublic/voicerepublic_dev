class Balance::CheckInOrdersController < ApplicationController
  
  layout 'dashboard'
  
  before_filter :authenticate_user!
  before_filter :set_user

  # GET /balance/check_in_orders/new
  # GET /balance/check_in_orders/new.json
  def new
    @balance_check_in_order = Balance::CheckInOrder.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @balance_check_in_order }
    end
  end

  # POST /balance/check_in_orders
  # POST /balance/check_in_orders.json
  def create
    @balance_check_in_order = Balance::CheckInOrder.new(params[:balance_check_in_order])
    @balance_check_in_order.balance_account = @user.balance_account
    logger.debug("CheckInOrdersController#create - debug: bcio: #{@balance_check_in_order.inspect}")
    
    respond_to do |format|
      if @balance_check_in_order.save
        format.html do
           flash.now[:notice] =  "Check in order created"
           render :action => :paypal and return
           #redirect_to( dashboard_url, notice: "Check in order was successfully created.") 
        end
        format.json { render json: @balance_check_in_order, status: :created, location: @balance_check_in_order }
      else
        flash.now[:error] =  "Check in order could not be created."
        logger.error("Balance::CheckInOrder#create - ERROR - #{@balance_check_in_order.errors.inspect}")
        format.html { render action: "new" }
        format.json { render json: @balance_check_in_order.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def paypal
    
  end


  # DELETE /balance/check_in_orders/1
  # DELETE /balance/check_in_orders/1.json
  def destroy
    @balance_check_in_order = Balance::CheckInOrder.find(params[:id])
    @balance_check_in_order.destroy

    respond_to do |format|
      format.html { redirect_to user_balance_account_url(:user_id => @user) }
      format.json { head :no_content }
    end
  end
  
  private
  
  def set_user
    @user = current_user
  end
end
