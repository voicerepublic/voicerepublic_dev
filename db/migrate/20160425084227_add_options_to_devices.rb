class AddOptionsToDevices < ActiveRecord::Migration[6.0]
  def change
    add_column :devices, :options, :text, default: '--- {}'
  end
end
