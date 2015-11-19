class CreateTagBundles < ActiveRecord::Migration
  def change
    create_table :tag_bundles do |t|
      t.string :title_en
      t.string :title_de

      t.timestamps null: false
    end
  end
end
