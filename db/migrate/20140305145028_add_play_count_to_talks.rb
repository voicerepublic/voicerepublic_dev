class AddPlayCountToTalks < ActiveRecord::Migration[6.0]
  def change
    add_column :talks, :play_count, :integer, default: 0
  end
end
