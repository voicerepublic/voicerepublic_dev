class AddStatusOrAboutToKlu < ActiveRecord::Migration
  def change
    add_column :klus, :uses_status, :boolean, :default => true
  end
end
