class ChangeColumnDefaultValuesForParticipantBases < ActiveRecord::Migration[6.0]
  def up
    change_column :participant_bases, :pay_tick_counter, :integer, :default => 0
    change_column :participant_bases, :seconds_online, :integer, :default => 0
  end

  def down
    change_column :participant_bases, :pay_tick_counter, :integer
    change_column :participant_bases, :seconds_online, :integer
  end
end
