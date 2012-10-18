class PaypalPayment < ActiveRecord::Base
  attr_accessible :amount_cents, :check_in_order_id, :currency, :params, :status, :tact_id
  
  belongs_to :check_in_order, :class_name => 'Balance::CheckInOrder'
  
end
