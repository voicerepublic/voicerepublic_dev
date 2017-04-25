class CreateOldEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.datetime :start_time
      t.integer :duration
      t.references :venue

      t.timestamps
    end
    add_index :events, :start_time
    add_index :events, :venue_id
  end
end
