class CreateComments < ActiveRecord::Migration[6.0]
  def self.up
    create_table :comments do |t|
      t.text :comment
      t.references :commentable, :polymorphic => true
      t.references :user
      t.timestamps
    end

    add_index :comments, :commentable_type
    add_index :comments, :commentable_id
    # add_index :comments, :user_id
  end

  def self.down
    drop_table :comments
  end
end
