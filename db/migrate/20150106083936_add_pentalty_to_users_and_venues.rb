class AddPentaltyToUsersAndVenues < ActiveRecord::Migration
  def change
    add_column :users, :penalty, :float, default: 1
    add_column :venues, :penalty, :float, default: 1
  end
end
