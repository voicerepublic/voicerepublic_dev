class RemoveGuestFromUsers < ActiveRecord::Migration[6.0]
  def change
    execute 'DELETE FROM users WHERE guest IS TRUE'
    remove_column :users, :guest
  end
end
