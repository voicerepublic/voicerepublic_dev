class CreateConversations < ActiveRecord::Migration[6.0]
  def change
    create_table :conversations do |t|
      #t.integer :user_id
      #t.integer :partner_id
      t.integer :user_1_id
      t.integer :user_2_id
      t.integer :offset_1
      t.integer :offset_2
      
      t.timestamps
    end
    
    add_column :messages, :conversation_id, :integer
    add_index :messages, :conversation_id
    
    add_index :conversations, :user_1_id
    add_index :conversations, :user_2_id
    
    #add_column :messages, :sender_conversation_id, :integer
    #add_column :messages, :receiver_conversation_id, :integer
    #add_index :messages, :sender_conversation_id
    #add_index :messages, :receiver_conversation_id
  end
end
