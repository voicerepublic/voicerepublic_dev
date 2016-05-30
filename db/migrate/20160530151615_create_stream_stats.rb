class CreateStreamStats < ActiveRecord::Migration
  def change
    create_table :stream_stats do |t|
      t.references :venue, index: true
      t.integer :listener_count
      t.integer :listener_peak
      t.integer :bitrate

      t.timestamps null: false
    end
    add_foreign_key :stream_stats, :venues
  end
end
