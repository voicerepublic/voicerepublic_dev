class CreateArtifacts < ActiveRecord::Migration[6.0]
  def change
    create_table :artifacts do |t|
      t.string :url
      t.string :context_type
      t.integer :context_id
      t.integer :size
      t.string :content_type
      t.text :metadata

      t.timestamps null: false
    end
  end
end
