class AddInitialTitleToPages < ActiveRecord::Migration[6.0]
  def change
    add_column :pages, :initial_title, :string
  end
end
