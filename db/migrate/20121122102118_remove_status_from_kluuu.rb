class RemoveStatusFromKluuu < ActiveRecord::Migration[6.0]
  def up
    remove_column :klus, :uses_status
  end

  def down
    add_column :klus, :uses_status, :boolean
  end
end
