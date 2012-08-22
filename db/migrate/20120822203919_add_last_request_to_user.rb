class AddLastRequestToUser < ActiveRecord::Migration
  def change
    add_column :users, :last_request_at, :timestamp
    add_column :users, :available, :string
  end
end
