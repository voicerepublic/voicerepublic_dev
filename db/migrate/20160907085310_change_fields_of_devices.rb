class ChangeFieldsOfDevices < ActiveRecord::Migration[6.0]
  def change
    add_column :devices, :mac_address_wifi, :string
    rename_column :devices, :mac_address, :mac_address_ethernet
  end
end
