class CreateBalanceCheckInOrders < ActiveRecord::Migration[6.0]
  def change
    create_table :balance_check_in_orders do |t|
      t.integer :credit_account_id
      t.boolean :completed
      t.timestamp :completed_at
      t.string :currency
      t.integer :amount

      t.timestamps
    end
  end
end
