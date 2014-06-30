class RenameRecordToCollectOnTalks < ActiveRecord::Migration
  def change
    rename_column :talks, :record, :collect
  end
end
