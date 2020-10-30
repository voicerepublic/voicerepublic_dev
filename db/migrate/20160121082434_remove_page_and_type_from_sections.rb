class RemovePageAndTypeFromSections < ActiveRecord::Migration[6.0]
  def change
    remove_column :sections, :type
    remove_column :sections, :page_id
  end
end
