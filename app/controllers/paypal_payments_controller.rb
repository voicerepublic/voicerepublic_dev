class PaypalPaymentsController < ApplicationController
  # GET /paypal_payments
  # GET /paypal_payments.json
  def index
    @paypal_payments = PaypalPayment.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @paypal_payments }
    end
  end

  # GET /paypal_payments/1
  # GET /paypal_payments/1.json
  def show
    @paypal_payment = PaypalPayment.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @paypal_payment }
    end
  end

  # GET /paypal_payments/new
  # GET /paypal_payments/new.json
  def new
    @paypal_payment = PaypalPayment.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @paypal_payment }
    end
  end

  # GET /paypal_payments/1/edit
  def edit
    @paypal_payment = PaypalPayment.find(params[:id])
  end

  # POST /paypal_payments
  # POST /paypal_payments.json
  def create
    @paypal_payment = PaypalPayment.new(params[:paypal_payment])

    respond_to do |format|
      if @paypal_payment.save
        format.html { redirect_to @paypal_payment, notice: 'Paypal payment was successfully created.' }
        format.json { render json: @paypal_payment, status: :created, location: @paypal_payment }
      else
        format.html { render action: "new" }
        format.json { render json: @paypal_payment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /paypal_payments/1
  # PUT /paypal_payments/1.json
  def update
    @paypal_payment = PaypalPayment.find(params[:id])

    respond_to do |format|
      if @paypal_payment.update_attributes(params[:paypal_payment])
        format.html { redirect_to @paypal_payment, notice: 'Paypal payment was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @paypal_payment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /paypal_payments/1
  # DELETE /paypal_payments/1.json
  def destroy
    @paypal_payment = PaypalPayment.find(params[:id])
    @paypal_payment.destroy

    respond_to do |format|
      format.html { redirect_to paypal_payments_url }
      format.json { head :no_content }
    end
  end
end
