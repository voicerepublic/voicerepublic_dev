class RemoveGuestFromUsers < ActiveRecord::Migration
  def change
    execute 'DELETE FROM users WHERE guest IS TRUE'
    remove_column :users, :guest
  end
end
