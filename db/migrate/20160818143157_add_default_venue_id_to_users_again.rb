class AddDefaultVenueIdToUsersAgain < ActiveRecord::Migration[6.0]
  def change
    add_reference :users, :default_venue, index: true
    #add_foreign_key :users, :default_venues
  end
end
