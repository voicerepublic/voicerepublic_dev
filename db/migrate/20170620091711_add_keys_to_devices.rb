class AddKeysToDevices < ActiveRecord::Migration
  def change
    add_column :devices, :box_public_key, :text
    add_column :devices, :jumphost_public_key, :text
    add_column :devices, :jumphost_private_key, :text
  end
end
