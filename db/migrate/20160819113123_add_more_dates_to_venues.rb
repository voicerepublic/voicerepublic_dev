class AddMoreDatesToVenues < ActiveRecord::Migration[6.0]
  def change
    add_column :venues, :disconnected_at, :datetime
    add_column :venues, :awaiting_stream_at, :datetime
  end
end
