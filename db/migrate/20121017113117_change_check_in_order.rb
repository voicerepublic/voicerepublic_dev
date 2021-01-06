class ChangeCheckInOrder < ActiveRecord::Migration[6.0]
  def change
    rename_column :balance_check_in_orders, :amount, :amount_cents
  end
end
