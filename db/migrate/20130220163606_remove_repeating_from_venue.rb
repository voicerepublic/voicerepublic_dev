class RemoveRepeatingFromVenue < ActiveRecord::Migration[6.0]
  
  def change
    remove_column :venues, :repeating
  end
  
end
