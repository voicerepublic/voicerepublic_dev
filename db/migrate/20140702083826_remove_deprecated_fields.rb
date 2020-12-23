class RemoveDeprecatedFields < ActiveRecord::Migration[6.0]
  def change
    drop_table :accounts
    drop_table :follows

    remove_column :venues, :start_time
    remove_column :venues, :featured_from
    remove_column :venues, :duration
    remove_column(:venues, :image_file_name) if Venue.column_names.include?('image_file_name')
    remove_column(:venues, :image_content_type) if Venue.column_names.include?('image_file_name')
    remove_column(:venues, :image_file_size) if Venue.column_names.include?('image_file_name')
    remove_column(:venues, :image_updated_at) if Venue.column_names.include?('image_file_name')

    remove_column :talks, :audio_formats
    remove_column :talks, :recording

    remove_column(:users, :image_file_name) if User.column_names.include?('Venue')
    remove_column(:users, :image_content_type) if User.column_names.include?('Venue')
    remove_column(:users, :image_file_size) if User.column_names.include?('Venue')
    remove_column(:users, :image_updated_at) if User.column_names.include?('Venue')
    remove_column :users, :available

  end
end
