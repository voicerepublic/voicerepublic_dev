class AddOwnerIdToPurchase < ActiveRecord::Migration
  def change
    add_column :purchases, :owner_id, :integer
  end
end
