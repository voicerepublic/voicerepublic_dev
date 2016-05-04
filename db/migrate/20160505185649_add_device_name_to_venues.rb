class AddDeviceNameToVenues < ActiveRecord::Migration
  def change
    add_column :venues, :device_name, :string
  end
end
