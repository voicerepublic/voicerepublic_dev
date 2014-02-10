class AddImageUidToTalks < ActiveRecord::Migration
  def change
    add_column :talks, :image_uid, :string
  end
end
