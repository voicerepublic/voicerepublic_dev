class ChangeCheckInOrder < ActiveRecord::Migration
  def change
    rename_column :balance_check_in_orders, :amount, :amount_cents
  end
end
