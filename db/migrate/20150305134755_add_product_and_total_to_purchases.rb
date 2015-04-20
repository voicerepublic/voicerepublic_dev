class AddProductAndTotalToPurchases < ActiveRecord::Migration
  def change
    add_column :purchases, :product, :string
    add_column :purchases, :total, :decimal
  end
end
