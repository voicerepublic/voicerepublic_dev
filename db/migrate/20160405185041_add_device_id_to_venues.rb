class AddDeviceIdToVenues < ActiveRecord::Migration
  def change
    add_reference :venues, :device, index: true
    add_foreign_key :venues, :devices
  end
end
