class AddPublicIpAddressToDevices < ActiveRecord::Migration
  def change
    add_column :devices, :public_ip_address, :string
  end
end
