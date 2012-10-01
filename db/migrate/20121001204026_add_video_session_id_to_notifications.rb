class AddVideoSessionIdToNotifications < ActiveRecord::Migration
  def change
    add_column :notification_bases, :video_session_id, :integer
  end
end
