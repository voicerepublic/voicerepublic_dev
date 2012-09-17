class ChangeAgainTableBookmarks < ActiveRecord::Migration
  change_table :bookmarks do |t|
    t.remove :description   
  end
end
