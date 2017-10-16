class RemoveStreamStats < ActiveRecord::Migration
  def up
    drop_table :stream_stats     
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
