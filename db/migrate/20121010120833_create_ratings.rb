class CreateRatings < ActiveRecord::Migration[6.0]
  def change
    create_table :ratings do |t|
      t.integer :rateable_id
      t.integer :user_id
      t.string :rateable_type
      t.text :content
      t.integer :score, :default => 0
      t.timestamps
    end
    add_index :ratings, :user_id
    add_index :ratings, :rateable_id
    add_index :ratings, :rateable_type
  end
end
