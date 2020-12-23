class AddMoreFieldsToTagBundles < ActiveRecord::Migration[6.0]
  def change
    add_column :tag_bundles, :description_en, :text
    add_column :tag_bundles, :description_de, :text
    add_column :tag_bundles, :promoted, :boolean, default: false
  end
end
