class AddAttachmentToVenues < ActiveRecord::Migration
  def up
    add_attachment :venues, :image
  end

  def down
    remove_attachment :venues, :image
  end
end
