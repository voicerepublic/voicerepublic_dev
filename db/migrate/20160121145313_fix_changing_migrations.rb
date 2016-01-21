class FixChangingMigrations < ActiveRecord::Migration
  def change
    change_column :sections, :content_as_html, :text, default: ''
    change_column :series, :description_as_html, :text, default: ''
    change_column :talks, :recording_override, :string, limit: 1024
    change_column :talks, :slides_uuid, :string, limit: 1024
    change_column :talks, :description_as_html, :text, default: ''
    change_column :talks, :icon, :string, default: 'default'
    change_column :users, :about_as_html, :text, default: ''
  end
end
