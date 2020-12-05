class AddDefaultToSectionContentAsHtml < ActiveRecord::Migration[6.0]
  def change
    change_column :sections, :content_as_html, :text, default: ''
  end
end
