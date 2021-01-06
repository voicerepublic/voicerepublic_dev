class AddPublicIpAddressToDevices < ActiveRecord::Migration[6.0]
  def change
    add_column :devices, :public_ip_address, :string
  end
end
