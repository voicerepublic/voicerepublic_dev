# encoding : utf-8

# Attributes:
# * id [integer, primary, not null] - primary key
# * amount_cents [integer] - TODO: document me
# * check_in_order_id [integer] - belongs to :check_in_order
# * created_at [datetime, not null] - creation time
# * currency [string] - TODO: document me
# * params [text] - TODO: document me
# * status [string] - TODO: document me
# * tact_id [string] - TODO: document me
# * updated_at [datetime, not null] - last update time

class PaypalPayment < ActiveRecord::Base

  attr_accessible :amount_cents, :check_in_order_id, :currency, :params, :status, :tact_id
  attr_accessible :amount
  serialize :params
  
  belongs_to :check_in_order, :class_name => 'Balance::CheckInOrder'
  
  monetize :amount_cents

  after_create :mark_checkin_complete

  validates :check_in_order_id, :presence => true
  
  validates_associated :check_in_order

  
  private
  
  def mark_checkin_complete
    self.logger.debug("PaypalPayment#mark_checkin_complete - DEBUG params: #{params.inspect}")
    
    if params[:payment_status] == "Completed" && 
                              params[:secret] == Balance::CheckInOrder::PAYPALCONFIG[:secret] &&
                              params[:receiver_email] == Balance::CheckInOrder::PAYPALCONFIG[:kluuu_account][:email] &&
                              params[:mc_gross].to_f == check_in_order.amount  &&
                              params[:mc_currency] == check_in_order.currency
        
      self.check_in_order.update_attributes(:completed => true, :completed_at => Time.now)

      account = self.check_in_order.balance_account
      
      account.balance = account.balance + self.check_in_order.amount
      account.save!
      logger.debug("PaypalPayment#mark_checkin_order_complete - SUCCESS check_in_order_id:  #{self.check_in_order.id}")
    else
      logger.error("\nPaypalPayment#mark_checkin_order_complete: ERROR \nparams[:secret]: #{params[:secret]}\nconfig secret: #{Balance::CheckInOrder::PAYPALCONFIG[:secret]}\nstatus: #{params[:payment_status]}\n")
    end
  end
  
  
  
  
end
