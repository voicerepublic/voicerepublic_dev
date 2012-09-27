class CreateNotificationBases < ActiveRecord::Migration
  def change
    create_table :notification_bases do |t|
      t.integer :user_id
      t.text :content
      t.string :type

      t.timestamps
    end
  end
end
