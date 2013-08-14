class AddImageToVenues < ActiveRecord::Migration
  def up
    add_attachment :users, :image
  end

  def down
    remove_attachment :users, :image
  end
end
