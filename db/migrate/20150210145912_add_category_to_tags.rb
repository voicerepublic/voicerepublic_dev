class AddCategoryToTags < ActiveRecord::Migration
  def change
    add_column :tags, :category, :boolean, default: false
    add_index :tags, :category
  end
end
