class CreateBookmarks < ActiveRecord::Migration[6.0]
  def change
    create_table :bookmarks do |t|
      t.integer :kluuu_id
      t.integer :user_id
      t.text :description

      t.timestamps
    end
  end
end
