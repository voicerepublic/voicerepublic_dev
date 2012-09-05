class ChangeCommentAttributes < ActiveRecord::Migration
  def up
    change_table :comments do |t|
      t.rename :comment, :content
    end
  end

  def down
    change_table :comments do |t|
      t.rename :content, :comment
    end
  end
end
