class CreateBalanceAccounts < ActiveRecord::Migration[6.0]
  def change
    create_table :balance_accounts do |t|
      t.string :currency
      t.integer :prepaid_cents, :default => 0
      t.integer :revenue_cents, :default => 0
      t.integer :user_id

      t.timestamps
    end
    
    rename_column :balance_check_in_orders, :credit_account_id, :balance_account_id
  end
end
