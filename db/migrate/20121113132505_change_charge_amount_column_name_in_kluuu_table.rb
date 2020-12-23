class ChangeChargeAmountColumnNameInKluuuTable < ActiveRecord::Migration[6.0]
  def up
    remove_column :klus, :charge_amount
    add_column :klus, :charge_cents, :integer, :default => 0
  end

  def down
    remove_column :klus, :charge_cents
    add_column :klus, :charge_amount, :integer, :default => 0
  end
end
