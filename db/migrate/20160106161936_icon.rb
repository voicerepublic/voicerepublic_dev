class Icon < ActiveRecord::Migration
  def change
    add_column :tag_bundles, :icon, :string
  end
end
