class AddAvatarUidToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :avatar_uid, :string
  end
end
