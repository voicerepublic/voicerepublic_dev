class AddImageUidToVenues < ActiveRecord::Migration[6.0]
  def change
    add_column :venues, :image_uid, :string
  end
end
