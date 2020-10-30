class MigrateRestFromAccountToUser < ActiveRecord::Migration[6.0]
  def change

    add_column :users, :timezone, :string
    add_column :users, :website, :string

    execute <<-SQL
      UPDATE users AS u SET
      timezone = a.timezone,
      website = a.website
      FROM accounts AS a WHERE a.user_id = u.id;
    SQL
    
  end
end
