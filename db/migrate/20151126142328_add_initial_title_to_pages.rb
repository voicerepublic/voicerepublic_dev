class AddInitialTitleToPages < ActiveRecord::Migration
  def change
    add_column :pages, :initial_title, :string
  end
end
