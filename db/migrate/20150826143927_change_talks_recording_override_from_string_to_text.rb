class ChangeTalksRecordingOverrideFromStringToText < ActiveRecord::Migration
  def change
    change_column :talks, :recording_override, :text
  end
end
