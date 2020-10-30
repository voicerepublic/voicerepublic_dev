class CreateVideoSessions < ActiveRecord::Migration[6.0]
  def change
    create_table :video_sessions do |t|
      t.integer :offer_id
      t.datetime :end_timestamp
      t.datetime :begin_timestamp
      t.string :video_system_session_id

      t.timestamps
    end
  end
end
