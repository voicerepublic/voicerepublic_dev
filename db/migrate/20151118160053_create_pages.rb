class CreatePages < ActiveRecord::Migration
  def change
    create_table :pages do |t|
      t.string :slug
      t.string :template, default: 'default'
      t.string :title_en
      t.string :title_de
      t.text :content_en
      t.text :content_de
      t.text :content_en_as_html
      t.text :content_de_as_html

      t.timestamps null: false
    end
  end
end
