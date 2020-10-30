class CreateEvents < ActiveRecord::Migration[6.0]
  def change
    create_table :events do |t|
      t.string :name
      t.references :source, polymorphic: true, index: true
      t.text :payload

      t.timestamps null: false
    end
  end
end
