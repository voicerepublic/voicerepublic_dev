class AddGroupToTagBundle < ActiveRecord::Migration
  def change
    add_column :tag_bundles, :group, :string
    add_index :tag_bundles, :group
  end
end
