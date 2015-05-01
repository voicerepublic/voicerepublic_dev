class RemoveOldTables < ActiveRecord::Migration
  def change
    drop_table :bookmarks
    drop_table :roles
    drop_table :status_updates
    drop_table :user_roles
  end
end
