class RenameTemplateToTypeOnPages < ActiveRecord::Migration
  def up
    rename_column :pages, :template, :type
    change_column :pages, :type, :string, default: 'Pages::Default'
  end
  def down
    rename_column :pages, :type, :template
    change_column :pages, :template, :string, default: 'default'
  end
end
