class AddHeaderUidToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :header_uid, :string
  end
end
