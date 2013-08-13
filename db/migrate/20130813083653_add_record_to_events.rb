class AddRecordToEvents < ActiveRecord::Migration
  def change
    add_column :events, :record, :boolean
  end
end
