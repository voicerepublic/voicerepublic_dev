class SetDefaultOfVenueDeviceName < ActiveRecord::Migration[6.0]
  def change
    change_column :venues, :device_name, :string, default: 'noop'
  end
end
