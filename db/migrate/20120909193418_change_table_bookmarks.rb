class ChangeTableBookmarks < ActiveRecord::Migration[6.0]
  
  def change
    change_table :bookmarks do |t|
      t.rename :kluuu_id, :klu_id
    end
  end

 
end
