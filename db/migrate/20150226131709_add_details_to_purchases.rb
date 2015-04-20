class AddDetailsToPurchases < ActiveRecord::Migration
  def change
    add_column :purchases, :details, :text
  end
end
