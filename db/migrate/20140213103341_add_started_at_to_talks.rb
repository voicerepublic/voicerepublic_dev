class AddStartedAtToTalks < ActiveRecord::Migration
  def change
    add_column :talks, :started_at, :datetime
  end
end
