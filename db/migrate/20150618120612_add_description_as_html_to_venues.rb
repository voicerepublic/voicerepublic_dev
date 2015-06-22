class AddDescriptionAsHtmlToVenues < ActiveRecord::Migration
  def change
    add_column :venues, :description_as_html, :text, default: ''
  end
end
