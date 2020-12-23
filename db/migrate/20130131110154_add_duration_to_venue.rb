class AddDurationToVenue < ActiveRecord::Migration[6.0]
  def change
    add_column :venues, :duration, :integer
    add_column :venues, :repeating, :integer
  end
end
