class AddDefaultToSectionContentAsHtml < ActiveRecord::Migration
  def change
    change_column :sections, :content_as_html, :text, default: ''
  end
end
