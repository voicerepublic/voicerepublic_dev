class AddPublisherTypeToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :publisher_type, :string
  end
end
