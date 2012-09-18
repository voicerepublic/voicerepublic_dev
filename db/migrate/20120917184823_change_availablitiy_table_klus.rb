class ChangeAvailablitiyTableKlus < ActiveRecord::Migration
  
  def up
    change_column(:klus, :available_at_times, :string)
  end
  
  def down
    change_column(:klus, :available_at_times, :text)
  end
end
