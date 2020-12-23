class AddKeysToDevices < ActiveRecord::Migration[6.0]
  def change
    add_column :devices, :box_public_key, :text
    add_column :devices, :jumphost_public_key, :text
    add_column :devices, :jumphost_private_key, :text
  end
end
