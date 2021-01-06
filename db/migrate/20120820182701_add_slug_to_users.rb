class AddSlugToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :slug, :text
    add_index :users, :slug, unique: true
  end
end
