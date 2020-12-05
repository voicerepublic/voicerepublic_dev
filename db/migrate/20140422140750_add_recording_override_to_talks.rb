class AddRecordingOverrideToTalks < ActiveRecord::Migration[6.0]
  def change
    add_column :talks, :recording_override, :string
  end
end
