class AddCommentReferences < ActiveRecord::Migration[6.0]
  def up
    change_table :comments do |t|
      t.references :commentable, :polymorphic => true
    end

    add_index :comments, :commentable_type
    add_index :comments, :commentable_id
  end

  def down
    change_table :comments do |t|
      t.remove :commentable_type
      t.remove :commentable_id
    end
  end
end
