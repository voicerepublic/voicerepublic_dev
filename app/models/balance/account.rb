# encoding : utf-8

# Attributes:
# * id [integer, primary, not null] - primary key
# * balance_cents [integer, default=0] - TODO: document me
# * created_at [datetime, not null] - creation time
# * currency [string] - TODO: document me
# * revenue_cents [integer, default=0] - TODO: document me
# * updated_at [datetime, not null] - last update time
# * user_id [integer] - belongs to :user

class Balance::Account < ActiveRecord::Base
  attr_accessible :currency, :balance_cents, :revenue_cents, :user_id
  attr_accessible :balance, :revenue
  
  belongs_to :user
  has_many :paypal_payments
  has_many :check_in_orders, :class_name => 'Balance::CheckInOrder', :foreign_key => 'balance_account_id'
  has_many :transfers, :foreign_key => 'account_id'
  
  monetize :balance_cents
  monetize :revenue_cents
  
  CURRENCIES = {"USD $" => "USD", "Euro €" => "EUR" }
  
  validates :user_id, :presence => true
  validates :currency, :presence => true
  
  #to check the balance against the charge of a kluuu
  #
  def check_balance(charge, tariff, time)
    ret = true                                               # free kluuu
    if tariff == 'minute'
      ret = (self.balance + self.revenue) >= (charge * time) # time based payment
    end
    if tariff == 'fix'
      ret = (self.balance + self.revenue) >= charge          # fixed payment
    end
    ret                                             
  end
  
end
