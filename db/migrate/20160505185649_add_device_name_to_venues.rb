class AddDeviceNameToVenues < ActiveRecord::Migration[6.0]
  def change
    add_column :venues, :device_name, :string
  end
end
