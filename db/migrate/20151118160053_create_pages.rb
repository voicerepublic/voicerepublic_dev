class CreatePages < ActiveRecord::Migration
  def change
    create_table :pages do |t|
      t.string :slug
      t.string :template
      t.string :title_en
      t.string :title_de
      t.text :content_en
      t.text :content_de

      t.timestamps null: false
    end
  end
end
