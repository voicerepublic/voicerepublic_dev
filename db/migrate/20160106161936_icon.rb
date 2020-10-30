class Icon < ActiveRecord::Migration[6.0]
  def change
    add_column :tag_bundles, :icon, :string
  end
end
