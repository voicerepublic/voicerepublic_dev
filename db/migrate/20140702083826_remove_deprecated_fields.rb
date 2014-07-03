class RemoveDeprecatedFields < ActiveRecord::Migration
  def change
    drop_table :accounts
    drop_table :follows

    remove_column :venues, :start_time
    remove_column :venues, :featured_from
    remove_column :venues, :duration
    remove_column :venues, :image_file_name
    remove_column :venues, :image_content_type
    remove_column :venues, :image_file_size
    remove_column :venues, :image_updated_at

    remove_column :talks, :audio_formats
    remove_column :talks, :recording

    remove_column :users, :image_file_name
    remove_column :users, :image_content_type
    remove_column :users, :image_file_size
    remove_column :users, :image_updated_at
    remove_column :users, :available
  end
end
