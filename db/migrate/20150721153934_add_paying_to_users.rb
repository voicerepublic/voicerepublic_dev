class AddPayingToUsers < ActiveRecord::Migration
  def change
    add_column :users, :paying, :boolean, default: false
  end
end
