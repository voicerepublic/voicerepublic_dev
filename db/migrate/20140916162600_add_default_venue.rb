class AddDefaultVenue < ActiveRecord::Migration
  def change
    add_column :users, :default_venue_id, :integer, :default => 0
  end
end
