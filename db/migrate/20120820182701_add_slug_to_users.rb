class AddSlugToUsers < ActiveRecord::Migration
  def change
    add_column :users, :slug, :text
    add_index :users, :slug, unique: true
  end
end
