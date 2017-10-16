class RemoveStreamStats < ActiveRecord::Migration
  def up
    drop_table :stream_stats     
    remove_foreign_key :stream_stats, :venues
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
