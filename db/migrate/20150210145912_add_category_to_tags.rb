class AddCategoryToTags < ActiveRecord::Migration[6.0]
  def change
    add_column :tags, :category, :boolean, default: false
    add_index :tags, :category
  end
end
