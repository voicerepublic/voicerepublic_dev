class AddImageUidToTalks < ActiveRecord::Migration[6.0]
  def change
    add_column :talks, :image_uid, :string
  end
end
