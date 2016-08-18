class AddDefaultVenueIdToUsersAgain < ActiveRecord::Migration
  def change
    add_reference :users, :default_venue, index: true
    #add_foreign_key :users, :default_venues
  end
end
