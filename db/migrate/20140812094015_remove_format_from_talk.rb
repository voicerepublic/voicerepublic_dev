class RemoveFormatFromTalk < ActiveRecord::Migration[6.0]
  def change
    remove_column :talks, :format
  end
end
