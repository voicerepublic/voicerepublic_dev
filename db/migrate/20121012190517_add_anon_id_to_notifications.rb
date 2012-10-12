class AddAnonIdToNotifications < ActiveRecord::Migration
  def change
    add_column :notification_bases, :anon_id, :string
  end
end
