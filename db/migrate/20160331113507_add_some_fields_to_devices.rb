class AddSomeFieldsToDevices < ActiveRecord::Migration
  def change
    add_column :devices, :loglevel, :integer, default: Logger::INFO
    add_column :devices, :report_interval, :integer, default: 60
    add_column :devices, :heartbeat_interval, :integer, default: 5
  end
end
