class AddDescriptionAsHtmlToVenues < ActiveRecord::Migration[6.0]
  def change
    add_column :venues, :description_as_html, :text, default: ''
  end
end
