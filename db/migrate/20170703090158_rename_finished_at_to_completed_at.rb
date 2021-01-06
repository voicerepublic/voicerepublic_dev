class RenameFinishedAtToCompletedAt < ActiveRecord::Migration[6.0]
  def change
    rename_column :jobs, :finished_at, :completed_at
  end
end
