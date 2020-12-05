class AddTypeFieldToVideoSession < ActiveRecord::Migration[6.0]
  def change
    add_column :video_session_bases, :type, :string
  end
end
