class Balance::CheckInOrdersController < ApplicationController
  
  layout 'dashboard'
  
  before_filter :authenticate_user!
  before_filter :set_user
  
  
  # GET /balance/check_in_orders
  # GET /balance/check_in_orders.json
  def index
    @balance_check_in_orders = Balance::CheckInOrder.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @balance_check_in_orders }
    end
  end

  # GET /balance/check_in_orders/1
  # GET /balance/check_in_orders/1.json
  def show
    @balance_check_in_order = Balance::CheckInOrder.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @balance_check_in_order }
    end
  end

  # GET /balance/check_in_orders/new
  # GET /balance/check_in_orders/new.json
  def new
    @balance_check_in_order = Balance::CheckInOrder.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @balance_check_in_order }
    end
  end

  # GET /balance/check_in_orders/1/edit
  def edit
    @balance_check_in_order = Balance::CheckInOrder.find(params[:id])
  end

  # POST /balance/check_in_orders
  # POST /balance/check_in_orders.json
  def create
    @balance_check_in_order = Balance::CheckInOrder.new(params[:balance_check_in_order])

    respond_to do |format|
      if @balance_check_in_order.save
        format.html { redirect_to @balance_check_in_order, notice: 'Check in order was successfully created.' }
        format.json { render json: @balance_check_in_order, status: :created, location: @balance_check_in_order }
      else
        format.html { render action: "new" }
        format.json { render json: @balance_check_in_order.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /balance/check_in_orders/1
  # PUT /balance/check_in_orders/1.json
  def update
    @balance_check_in_order = Balance::CheckInOrder.find(params[:id])

    respond_to do |format|
      if @balance_check_in_order.update_attributes(params[:balance_check_in_order])
        format.html { redirect_to @balance_check_in_order, notice: 'Check in order was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @balance_check_in_order.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /balance/check_in_orders/1
  # DELETE /balance/check_in_orders/1.json
  def destroy
    @balance_check_in_order = Balance::CheckInOrder.find(params[:id])
    @balance_check_in_order.destroy

    respond_to do |format|
      format.html { redirect_to balance_check_in_orders_url }
      format.json { head :no_content }
    end
  end
  
  private
  
  def set_user
    @user = @user || current_user
  end
end
