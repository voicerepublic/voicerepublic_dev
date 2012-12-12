# encoding : utf-8

class PaypalPaymentsController < ApplicationController
  

  # POST /paypal_payments
  # POST /paypal_payments.json
  def create
    #begin 
      convert_charset() 
    #rescue Exception => e
    #  logger.error("PaypalPayment#create - charset conversion failed: #{e.to_s}")
    #  raise 
      #render :status => 500 and return
    #end
    pms = params.symbolize_keys
    logger.debug("PaypalPayments#create - #{params.inspect}")
    @paypal_payment = PaypalPayment.create!(:params => pms, 
                              :check_in_order_id => params[:invoice].to_i, 
                              :status => params[:payment_status], 
                              :tact_id => params[:txn_id], 
                              :amount_cents => params[:mc_gross].to_f * 100, 
                              #:amount => params[:mc_gross].to_f,
                              :currency => params[:mc_currency])
    logger.error("PaypalPayments#create: errors: #{@paypal_payment.errors.inspect}") unless @paypal_payment.errors.empty?
    logger.info("\PaypalPayments#create - info: - cpn-id: #{@paypal_payment.id}: #{@paypal_payment.inspect}\n")
   
    if @paypal_payment.valid?
      logger.debug("PaypalPayment#create - is a valid!")
       render :nothing => true and return
    else
      logger.error("PaypalPayment#create - ERROR - #{@paypal_payment.errors.inspect}")
      raise 
      #render :status => 500
    end
  end

  private
  
  # convert any charset not utf-8 to utf-8
  #
  def convert_charset
    unless params["charset"] =~ /(?i:utf)-8/
      logger.debug("CheckInPaymentNotifications#convert_charset from: #{params['charset']} to utf-8")
      params.each_pair { |k,v| v.to_s.encode( "utf-8", params["charset"] ) }
    end
  end
  
end
