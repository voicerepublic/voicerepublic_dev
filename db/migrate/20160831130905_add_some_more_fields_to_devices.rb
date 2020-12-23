class AddSomeMoreFieldsToDevices < ActiveRecord::Migration[6.0]
  def change
    add_column :devices, :source_branch, :string, default: 'master'
    add_column :devices, :capture_device, :string, default: 'dsnooped'
  end
end
