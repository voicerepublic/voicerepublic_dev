class AddPublisherTypeToUsers < ActiveRecord::Migration
  def change
    add_column :users, :publisher_type, :string
  end
end
