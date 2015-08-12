class CreateNewVenues < ActiveRecord::Migration
  def change
    create_table :venues do |t|
      t.string :name
      t.string :slug
      t.references :user, index: true
      t.text :options, default: '---\n{}'
      t.decimal :lat, default: 47.374707
      t.decimal :long, default: 8.5249116

      t.timestamps null: false
    end
    add_index :venues, :slug
    add_foreign_key :venues, :users
  end
end
