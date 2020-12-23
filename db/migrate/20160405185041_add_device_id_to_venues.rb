class AddDeviceIdToVenues < ActiveRecord::Migration[6.0]
  def change
    add_reference :venues, :device, index: true
    add_foreign_key :venues, :devices
  end
end
