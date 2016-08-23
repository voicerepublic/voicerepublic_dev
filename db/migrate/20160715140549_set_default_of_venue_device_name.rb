class SetDefaultOfVenueDeviceName < ActiveRecord::Migration
  def change
    change_column :venues, :device_name, :string, default: 'noop'
  end
end
