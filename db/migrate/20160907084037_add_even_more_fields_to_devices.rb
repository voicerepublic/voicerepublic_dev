class AddEvenMoreFieldsToDevices < ActiveRecord::Migration
  def change
    add_column :devices, :private_ip_address, :string
    add_column :devices, :mac_address, :string
    add_column :devices, :version, :string
  end
end
