class AddRecordingIntoVenues < ActiveRecord::Migration[6.0]
  def change
    add_column :venues, :recording, :string
  end
end
