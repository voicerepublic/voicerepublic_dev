class CreateKluImages < ActiveRecord::Migration[6.0]
  def change
    create_table :klu_images do |t|
      t.text :description
      t.integer :klu_id
      #t.attachment :image
      t.timestamps
    end
  end
end

