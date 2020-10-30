class AddAboutAsHtmlToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :about_as_html, :text, default: ''
  end
end
