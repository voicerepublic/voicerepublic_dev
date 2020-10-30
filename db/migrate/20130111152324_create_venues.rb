class CreateVenues < ActiveRecord::Migration[6.0]
  def change
    create_table :venues do |t|
      t.integer :host_kluuu_id
      t.timestamp :start_time
      t.text :description
      t.string :title
      t.string :intro_video

      t.timestamps
    end
    
    create_table :venue_klus do |t|
      t.integer :venue_id
      t.integer :klu_id
      
      t.timestamps
    end
    
    add_index :venue_klus, :venue_id
    
    #Role.create!(:name => 'venue_host')
    
  end
  
  
end
