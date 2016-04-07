class CreateListeners < ActiveRecord::Migration
  def change
    create_table :listeners do |t|
      t.references :talk, index: true
      t.references :user, index: true
      t.string :session

      t.timestamps null: false
    end
    add_foreign_key :listeners, :talks
    add_foreign_key :listeners, :users
  end
end
