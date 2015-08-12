class AddVenueIdToTalks < ActiveRecord::Migration
  def change
    add_reference :talks, :venue, index: true
    add_foreign_key :talks, :venues
  end
end
