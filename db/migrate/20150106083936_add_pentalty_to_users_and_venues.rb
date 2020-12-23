class AddPentaltyToUsersAndVenues < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :penalty, :float, default: 1
    add_column :venues, :penalty, :float, default: 1
  end
end
