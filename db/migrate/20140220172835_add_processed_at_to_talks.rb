class AddProcessedAtToTalks < ActiveRecord::Migration[6.0]
  def change
    add_column :talks, :processed_at, :datetime
  end
end
