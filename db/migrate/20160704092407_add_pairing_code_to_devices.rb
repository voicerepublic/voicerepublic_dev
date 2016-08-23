class AddPairingCodeToDevices < ActiveRecord::Migration
  def change
    add_column :devices, :pairing_code, :string
    add_index :devices, :pairing_code
  end
end
