class RemoveRepeatingFromVenue < ActiveRecord::Migration
  
  def change
    remove_column :venues, :repeating
  end
  
end
