class AddOwnerIdToPurchase < ActiveRecord::Migration[6.0]
  def change
    add_column :purchases, :owner_id, :integer
  end
end
