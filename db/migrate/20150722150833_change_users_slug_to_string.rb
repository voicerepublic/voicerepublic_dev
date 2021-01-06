class ChangeUsersSlugToString < ActiveRecord::Migration[6.0]
  def change
    change_column :users, :slug, :string
  end
end
