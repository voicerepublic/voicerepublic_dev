class AddReferrerToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :referrer, :string
  end
end
