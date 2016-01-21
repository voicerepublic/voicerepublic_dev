class RemovePageAndTypeFromSections < ActiveRecord::Migration
  def change
    remove_column :sections, :type
    remove_column :sections, :page_id
  end
end
