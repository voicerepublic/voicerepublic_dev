class AddPayingToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :paying, :boolean, default: false
  end
end
