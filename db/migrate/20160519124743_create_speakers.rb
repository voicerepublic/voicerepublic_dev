class CreateSpeakers < ActiveRecord::Migration
  def change
    create_table :speakers do |t|
      t.string :fullname
      t.string :profession

      t.timestamps null: false
    end
  end
end
