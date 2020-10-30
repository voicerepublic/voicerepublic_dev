class AddTargetToDevices < ActiveRecord::Migration[6.0]
  def change
    add_column :devices, :target, :string, default: 'live'
  end
end
