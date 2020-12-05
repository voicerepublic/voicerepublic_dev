class CreateMessagesOld < ActiveRecord::Migration[6.0]
  def change
    create_table :messages do |t|
      t.integer :receiver_id
      t.integer :sender_id
      t.text :content
      t.boolean :receiver_read, :default => false
      t.boolean :sender_read, :default => false

      t.timestamps
    end
  end
end
