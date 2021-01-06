class CreateParticipants < ActiveRecord::Migration[6.0]
  def change
    create_table :participants do |t|
      t.string :type
      t.integer :video_session_id
      t.datetime :entered_timestamp
      t.datetime :left_timestamp
      t.string :room_url
      t.string :video_session_role
      t.string :user_cookie_session_id
      t.integer :user_id
      t.integer :seconds_online
      t.datetime :last_pay_tick_timestamp
      t.integer :pay_tick_counter
      t.datetime :payment_started_timestamp
      t.datetime :payment_stopped_timestamp

      t.timestamps
    end
  end
end
