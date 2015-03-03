class AddTaggingsCountToTags < ActiveRecord::Migration
  def change
    add_column :tags, :taggings_count, :integer, default: 0
    add_index :tags, :taggings_count
  end
end
