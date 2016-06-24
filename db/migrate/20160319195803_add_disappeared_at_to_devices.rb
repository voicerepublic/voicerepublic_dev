class AddDisappearedAtToDevices < ActiveRecord::Migration
  def change
    add_column :devices, :disappeared_at, :datetime
  end
end
