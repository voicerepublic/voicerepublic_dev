class ChangeFieldsOfDevices < ActiveRecord::Migration
  def change
    add_column :devices, :mac_address_wifi, :string
    rename_column :devices, :mac_address, :mac_address_ethernet
  end
end
