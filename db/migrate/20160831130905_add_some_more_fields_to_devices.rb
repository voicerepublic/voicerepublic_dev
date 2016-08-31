class AddSomeMoreFieldsToDevices < ActiveRecord::Migration
  def change
    add_column :devices, :source_branch, :string, default: 'master'
    add_column :devices, :capture_device, :string, default: 'dsnooped'
  end
end
