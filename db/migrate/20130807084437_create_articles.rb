class CreateArticles < ActiveRecord::Migration[6.0]
  def change
    create_table :articles do |t|
      t.references :venue
      t.text :content
      t.references :user

      t.timestamps
    end
    # add_index :articles, :venue_id
    # add_index :articles, :user_id
  end
end
