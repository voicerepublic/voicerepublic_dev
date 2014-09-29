class AddDefaultVenueIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :default_venue_id, :integer
  end
end
