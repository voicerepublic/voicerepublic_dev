class RenameRecordToCollectOnTalks < ActiveRecord::Migration[6.0]
  def change
    rename_column :talks, :record, :collect
  end
end
