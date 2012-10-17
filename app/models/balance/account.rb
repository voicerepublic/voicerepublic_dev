# encoding : utf-8

class Balance::Account < ActiveRecord::Base
  attr_accessible :currency, :prepaid_cents, :revenue_cents, :user_id
  attr_accessible :prepaid, :revenue
  
  belongs_to :user
  
  monetize :prepaid_cents
  monetize :revenue_cents
  
  CURRENCIES = {"USD $" => "USD", "Euro €" => "EUR" }
  
  #validates_presence_of :currency, :prepaid_cents, :revenue_cents
  
  #to check the balance against the charge of a kluuu
  def check_balance(charge, tariff, time)
    
    if (tariff == 'minute')
      
      #check if the user has enough money for a given time 
      if (((self.prepaid + self.revenue) <=> (charge * Integer(time))) < 0)
        return false
      else
        return true
      end
    
    elsif (tariff == 'fix')
      
      #check if the user has enough money to pay the fixed price 
      if (((self.prepaid + self.revenue) <=> charge) < 0)
        return false
      else
        return true
      end
    
    else
      
      #is only returned if check_balance is called for a free kluuu
      return true
    
    end
  end
  
  
end
