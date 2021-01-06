class RefactorPages < ActiveRecord::Migration[6.0]
  def up
    remove_column :pages, :title_de
    remove_column :pages, :content_de
    remove_column :pages, :content_de_as_html
    rename_column :pages, :title_en, :title
    rename_column :pages, :content_en, :content
    rename_column :pages, :content_en_as_html, :content_as_html
  end
  def down
    add_column :pages, :title_de, :text
    add_column :pages, :content_de, :text
    add_column :pages, :content_de_as_html, :text
    rename_column :pages, :title, :title_en
    rename_column :pages, :content, :content_en
    rename_column :pages, :content_as_html, :content_en_as_html
  end
end
