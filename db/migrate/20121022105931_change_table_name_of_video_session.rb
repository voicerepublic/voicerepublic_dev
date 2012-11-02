class ChangeTableNameOfVideoSession < ActiveRecord::Migration
  def up
    rename_table :video_sessions, :video_session_bases
  end

  def down
    rename_table :video_session_bases, :video_sessions
  end
end
