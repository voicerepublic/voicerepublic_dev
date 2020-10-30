class CreateVideoRooms < ActiveRecord::Migration[6.0]
  def change
    create_table :video_rooms do |t|
      t.integer :video_server_id
      t.integer :video_session_id
      t.integer :participant_count
      t.string :video_system_room_id
      t.string :name
      t.string :guest_password
      t.string :host_password
      t.string :welcome_msg

      t.timestamps
    end
    add_index :video_rooms, :video_system_room_id, :unique => true
  end
end
