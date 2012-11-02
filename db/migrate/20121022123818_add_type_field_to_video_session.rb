class AddTypeFieldToVideoSession < ActiveRecord::Migration
  def change
    add_column :video_session_bases, :type, :string
  end
end
