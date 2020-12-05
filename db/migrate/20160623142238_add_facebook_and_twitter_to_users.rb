class AddFacebookAndTwitterToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :facebook, :string
    add_column :users, :twitter, :string
  end
end
