class AddOptionsToDevices < ActiveRecord::Migration
  def change
    add_column :devices, :options, :text, default: '--- {}'
  end
end
