class AddDisappearedAtToDevices < ActiveRecord::Migration[6.0]
  def change
    add_column :devices, :disappeared_at, :datetime
  end
end
