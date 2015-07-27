class ChangeUsersSlugToString < ActiveRecord::Migration
  def change
    change_column :users, :slug, :string
  end
end
