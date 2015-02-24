class AddIndexAndDataMigrationToUsers < ActiveRecord::Migration
  def change

    add_index :users, :confirmation_token, unique: true

    # set all existing users to confirmed
    execute("UPDATE users SET confirmed_at = NOW()")

  end
end
