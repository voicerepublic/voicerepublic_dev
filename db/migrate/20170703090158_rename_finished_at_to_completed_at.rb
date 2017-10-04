class RenameFinishedAtToCompletedAt < ActiveRecord::Migration
  def change
    rename_column :jobs, :finished_at, :completed_at
  end
end
