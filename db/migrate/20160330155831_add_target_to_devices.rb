class AddTargetToDevices < ActiveRecord::Migration
  def change
    add_column :devices, :target, :string, default: 'live'
  end
end
