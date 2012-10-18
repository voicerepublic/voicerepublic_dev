class ChangeBalanceAccount < ActiveRecord::Migration
  
  def change
    rename_column :balance_accounts, :prepaid_cents, :balance_cents
  end

end
