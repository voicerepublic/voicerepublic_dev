class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.integer :receiver_id
      t.integer :sender_id
      t.text :content
      t.boolean :receiver_read
      t.boolean :sender_read

      t.timestamps
    end
  end
end
