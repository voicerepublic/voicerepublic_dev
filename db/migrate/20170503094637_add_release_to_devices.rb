class AddReleaseToDevices < ActiveRecord::Migration
  def change
    add_column :devices, :release, :string
  end
end
