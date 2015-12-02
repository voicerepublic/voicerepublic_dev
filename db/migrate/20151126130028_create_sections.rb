class CreateSections < ActiveRecord::Migration
  def change
    create_table :sections do |t|
      t.references :page
      t.string :type
      t.string :locale
      t.string :key
      t.text :content
      t.text :content_as_html

      t.timestamps null: false
    end
    add_index :sections, :page_id
    add_index :sections, :locale
    add_index :sections, :key
  end
end
