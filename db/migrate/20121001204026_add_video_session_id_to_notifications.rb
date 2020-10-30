class AddVideoSessionIdToNotifications < ActiveRecord::Migration[6.0]
  def change
    add_column :notification_bases, :video_session_id, :integer
  end
end
