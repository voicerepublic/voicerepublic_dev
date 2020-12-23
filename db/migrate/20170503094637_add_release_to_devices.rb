class AddReleaseToDevices < ActiveRecord::Migration[6.0]
  def change
    add_column :devices, :release, :string
  end
end
