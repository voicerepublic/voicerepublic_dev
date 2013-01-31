class AddDurationToVenue < ActiveRecord::Migration
  def change
    add_column :venues, :duration, :integer
    add_column :venues, :repeating, :integer
  end
end
