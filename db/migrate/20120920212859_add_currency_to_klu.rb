class AddCurrencyToKlu < ActiveRecord::Migration
  def change
    add_column :klus, :charge_amount, :integer, :default => 0
    add_column :klus, :charge_type, :string, :default => :free
    add_index :klus, :charge_type
  end
end
