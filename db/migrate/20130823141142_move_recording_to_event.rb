class MoveRecordingToEvent < ActiveRecord::Migration[6.0]
  def up
    add_column :events, :recording, :string
    remove_column :venues, :recording
  end

  def down
    remove_column :events, :recording
    add_column :venues, :recording, :string
  end
end
