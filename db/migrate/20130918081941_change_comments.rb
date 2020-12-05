class ChangeComments < ActiveRecord::Migration[6.0]
  def up
    # TODO another really bad one
    # Comment.delete_all

    change_table(:comments) do |t|
      t.remove :commentable_id
      t.remove :commentable_type
      t.change :user_id, :integer, :null => false
      t.column :article_id, :integer, :null => false
    end
  end

  def down
    change_table(:comments) do |t|
      t.column :commentable_id, :integer
      t.column :commentable_type, :commentable_type
      t.change :user_id, :integer, :null => true
      t.remove :article_id
    end
  end
end
