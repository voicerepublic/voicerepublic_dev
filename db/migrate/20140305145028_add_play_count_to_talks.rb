class AddPlayCountToTalks < ActiveRecord::Migration
  def change
    add_column :talks, :play_count, :integer, default: 0
  end
end
