class RemoveOldTables < ActiveRecord::Migration
  def change
    drop_table :bookmarks      if exists? :bookmarks
    drop_table :roles          if exists? :roles
    drop_table :status_updates if exists? :status_updates
    drop_table :user_roles     if exists? :user_roles
  end

  def exists?(table)
    ActiveRecord::Base.connection.table_exists? table
  end
end
