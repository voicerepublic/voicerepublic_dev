class CreateStatusUpdates < ActiveRecord::Migration
  def change
    create_table :status_updates do |t|
      t.text :content
      t.integer :user_id

      t.timestamps
    end
  end
end
