class AddRecordingOverrideToTalks < ActiveRecord::Migration
  def change
    add_column :talks, :recording_override, :string
  end
end
