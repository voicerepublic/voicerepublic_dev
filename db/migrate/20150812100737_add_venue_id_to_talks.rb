class AddVenueIdToTalks < ActiveRecord::Migration[6.0]
  def change
    add_reference :talks, :venue, index: true
    add_foreign_key :talks, :venues
  end
end
