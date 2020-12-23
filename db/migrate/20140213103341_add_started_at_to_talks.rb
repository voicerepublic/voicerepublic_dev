class AddStartedAtToTalks < ActiveRecord::Migration[6.0]
  def change
    add_column :talks, :started_at, :datetime
  end
end
