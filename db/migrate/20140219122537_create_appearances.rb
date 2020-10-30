class CreateAppearances < ActiveRecord::Migration[6.0]
  def change
    create_table :appearances do |t|
      t.references :user, index: true
      t.references :talk, index: true

      t.timestamps
    end
  end
end
