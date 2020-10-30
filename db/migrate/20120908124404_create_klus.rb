class CreateKlus < ActiveRecord::Migration[6.0]
  def change
    create_table :klus do |t|
      t.string :title
      t.text :description
      t.text :available_at_times
      t.integer :user_id
      t.boolean :published, :default => false
      t.integer :category_id
      t.string :type

      t.timestamps
    end
  end
end
