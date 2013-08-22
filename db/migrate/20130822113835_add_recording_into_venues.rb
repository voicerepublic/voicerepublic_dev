class AddRecordingIntoVenues < ActiveRecord::Migration
  def change
    add_column :venues, :recording, :string
  end
end
