class AddDescriptionAsHtmlToTalks < ActiveRecord::Migration[6.0]
  def change
    add_column :talks, :description_as_html, :text, default: ''
  end
end
