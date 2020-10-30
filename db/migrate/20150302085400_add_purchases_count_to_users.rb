class AddPurchasesCountToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :purchases_count, :integer, default: 0
    add_index :users, :purchases_count
  end
end
