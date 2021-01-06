class CreateNotificationBases < ActiveRecord::Migration[6.0]
  def change
    create_table :notification_bases do |t|
      t.integer :user_id
      t.text :content
      t.integer :klu_id
      t.integer :other_id
      t.string :url
      t.string :type
      t.boolean :read, :default => false

      t.timestamps
    end
    add_index :notification_bases, :user_id
  end
end
