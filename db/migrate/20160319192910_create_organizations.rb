class CreateOrganizations < ActiveRecord::Migration
  def change
    create_table :organizations do |t|
      t.string :name
      t.string :slug
      t.integer :credits
      t.string :image_uid
      t.string :image_name
      t.string :image_alt
      t.string :logo_uid
      t.string :logo_name
      t.string :logo_alt
      t.text :description
      t.text :description_as_html
      t.text :description_as_text
      t.string :website
      t.float :penalty
      t.boolean :paying
      t.datetime :featured_from
      t.datetime :featured_until

      t.timestamps null: false
    end
  end
end
