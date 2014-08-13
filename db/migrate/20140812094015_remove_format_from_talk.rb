class RemoveFormatFromTalk < ActiveRecord::Migration
  def change
    remove_column :talks, :format
  end
end
