class AddImageUidToVenues < ActiveRecord::Migration
  def change
    add_column :venues, :image_uid, :string
  end
end
