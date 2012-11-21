class DeleteVersionFieldFromVideoServers < ActiveRecord::Migration
  def up
    remove_column :video_servers, :version
  end

  def down
    add_column :video_servers, :version, :string
  end
end
