class CreateTalks < ActiveRecord::Migration[6.0]
  def change
    create_table :talks do |t|
      t.string :title
      t.references :venue
      t.datetime :starts_at
      t.datetime :ends_at
      t.datetime :ended_at
      t.boolean :record
      t.string :recording

      t.timestamps
    end
  end
end
