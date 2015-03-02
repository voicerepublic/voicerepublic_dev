class AddPurchasesCountToUsers < ActiveRecord::Migration
  def change
    add_column :users, :purchases_count, :integer, default: 0
    add_index :users, :purchases_count
  end
end
