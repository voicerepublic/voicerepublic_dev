# encoding : utf-8

class Balance::Account < ActiveRecord::Base
  attr_accessible :currency, :balance_cents, :revenue_cents, :user_id
  attr_accessible :balance, :revenue
  
  belongs_to :user
  has_many :paypal_payments
  
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
