class AddDetailsToPurchases < ActiveRecord::Migration[6.0]
  def change
    add_column :purchases, :details, :text
  end
end
