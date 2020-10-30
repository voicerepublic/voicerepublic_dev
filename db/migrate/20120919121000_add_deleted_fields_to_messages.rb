class AddDeletedFieldsToMessages < ActiveRecord::Migration[6.0]
  def change
    add_column :messages, :sender_deleted, :boolean, :default => false
    add_column :messages, :receiver_deleted, :boolean, :default => false
    
    add_index :messages, :receiver_id
    add_index :messages, :sender_id
  end
end
