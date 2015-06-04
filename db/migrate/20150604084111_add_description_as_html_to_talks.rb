class AddDescriptionAsHtmlToTalks < ActiveRecord::Migration
  def change
    add_column :talks, :description_as_html, :text
  end
end
