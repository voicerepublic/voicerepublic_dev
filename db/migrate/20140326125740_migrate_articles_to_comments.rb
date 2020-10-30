class MigrateArticlesToComments < ActiveRecord::Migration[6.0]
  def change

    remove_column :comments, :article_id

    # screw comments
    execute <<-SQL
      DELETE FROM comments;

      INSERT INTO comments (commentable_id, commentable_type, content,
      created_at, updated_at, user_id) SELECT venue_id, 'Venue', content,
      created_at, updated_at, user_id FROM articles;
    SQL
    
    drop_table :articles
    
  end
end
