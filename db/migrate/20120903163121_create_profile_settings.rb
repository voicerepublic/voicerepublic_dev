class CreateProfileSettings < ActiveRecord::Migration[6.0]
  def change
    create_table :profile_settings do |t|
      t.string :timezone
      t.string :language_1
      t.string :language_2
      t.string :language_3
      t.integer :user_id
      t.text :about

      t.timestamps
    end
    
    #add_attachment :profile_settings, :portrait
  end
end
