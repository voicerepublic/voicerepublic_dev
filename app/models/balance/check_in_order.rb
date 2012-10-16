class Balance::CheckInOrder < ActiveRecord::Base
  attr_accessible :amount, :completed, :completed_at, :credit_account_id, :currency
  
  
end
