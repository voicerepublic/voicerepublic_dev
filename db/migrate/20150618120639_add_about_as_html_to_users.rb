class AddAboutAsHtmlToUsers < ActiveRecord::Migration
  def change
    add_column :users, :about_as_html, :text, default: ''
  end
end
