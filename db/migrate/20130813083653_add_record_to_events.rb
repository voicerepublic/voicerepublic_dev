class AddRecordToEvents < ActiveRecord::Migration[6.0]
  def change
    add_column :events, :record, :boolean
  end
end
