class ChangeAgainTableBookmarks < ActiveRecord::Migration[6.0]
  change_table :bookmarks do |t|
    t.remove :description   
  end
end
