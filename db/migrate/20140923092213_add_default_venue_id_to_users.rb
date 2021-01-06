class AddDefaultVenueIdToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :default_venue_id, :integer
  end
end
