class CleanupPage < ActiveRecord::Migration
  def change

    change_column :pages, :type, :string, default: 'default'
    remove_column :pages, :title
    remove_column :pages, :content
    remove_column :pages, :content_as_html

  end
end
