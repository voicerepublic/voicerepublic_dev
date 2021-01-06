class AddAnonIdToNotifications < ActiveRecord::Migration[6.0]
  def change
    add_column :notification_bases, :anon_id, :string
  end
end
