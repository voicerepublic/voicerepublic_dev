class AddProductAndTotalToPurchases < ActiveRecord::Migration[6.0]
  def change
    add_column :purchases, :product, :string
    add_column :purchases, :total, :decimal
  end
end
