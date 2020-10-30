class ChangeBalanceAccount < ActiveRecord::Migration[6.0]
  
  def change
    rename_column :balance_accounts, :prepaid_cents, :balance_cents
  end

end
