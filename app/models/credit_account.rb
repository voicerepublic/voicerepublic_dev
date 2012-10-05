class CreditAccount < ActiveRecord::Base
  
  belongs_to :user
  
  attr_accessible :currency, :prepaid_amount, :revenue_amount, :user_id
  
  validates_presence_of :currency, :prepaid_amount, :revenue_amount
  
  composed_of :prepaid,
              :class_name => "Money",
              :mapping => [%w(prepaid_amount cents), %w(currency currency_as_string)],
              :constructor => Proc.new { |cents , currency| Money.new(cents || 0, currency) },
              :converter => Proc.new { |value| value.respond_to?(:to_money) ? value.to_money : raise(ArgumentError, "Can't convert #{value.class} to Money") }
  
  composed_of :revenue,
              :class_name => "Money",
              :mapping => [%w(revenue_amount cents), %w(currency currency_as_string)],
              :constructor => Proc.new { |cents, currency| Money.new(cents || 0, currency) },
              :converter => Proc.new { |value| value.respond_to?(:to_money) ? value.to_money : raise(ArgumentError, "Can't convert #{value.class} to Money") }
              
  
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
