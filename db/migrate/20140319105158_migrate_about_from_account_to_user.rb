class MigrateAboutFromAccountToUser < ActiveRecord::Migration
  def change

    add_column :users, :about, :text

    execute <<-SQL
      UPDATE users AS u SET about = a.about FROM accounts AS a WHERE a.user_id = u.id;
    SQL

  end
end
