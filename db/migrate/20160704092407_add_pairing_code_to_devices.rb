class AddPairingCodeToDevices < ActiveRecord::Migration[6.0]
  def change
    add_column :devices, :pairing_code, :string
    add_index :devices, :pairing_code
  end
end
