class AddHeaderUidToUsers < ActiveRecord::Migration
  def change
    add_column :users, :header_uid, :string
  end
end
