class AddProcessedAtToTalks < ActiveRecord::Migration
  def change
    add_column :talks, :processed_at, :datetime
  end
end
