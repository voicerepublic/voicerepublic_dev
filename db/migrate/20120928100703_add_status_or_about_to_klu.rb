class AddStatusOrAboutToKlu < ActiveRecord::Migration[6.0]
  def change
    add_column :klus, :uses_status, :boolean, :default => true
  end
end
