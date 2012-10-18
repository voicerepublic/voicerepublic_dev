# encoding : utf-8

class PaypalPaymentsController < ApplicationController
  

  # POST /paypal_payments
  # POST /paypal_payments.json
  def create
    convert_charset()
    pms = params.symbolize_keys
    
    cipn = PaypalPayment.create!(:params => pms, 
                              :check_in_order_id => params[:invoice].to_i, 
                              :status => params[:payment_status], 
                              :tact_id => params[:txn_id], 
                              :amount => params[:mc_gross].to_f, 
                              :currency => params[:mc_currency])
    
    logger.info("\PaypalPayments#create - info: - cpn-id: #{cipn.id}: #{cipn.inspect}\n")
    render :nothing => true
  end

  private
  
  # convert any charset not utf-8 to utf-8
  #
  def convert_charset
    unless params["charset"] =~ /(?i:utf)-8/
      logger.debug("CheckInPaymentNotifications#convert_charset from: #{params['charset']} to utf-8")
      params.each_pair { |k,v| v.encode( "utf-8", params["charset"] ) }
    end
  end
  
end
