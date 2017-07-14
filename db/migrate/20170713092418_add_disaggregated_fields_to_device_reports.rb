class AddDisaggregatedFieldsToDeviceReports < ActiveRecord::Migration
  def change
    add_column :device_reports, :uptime, :integer
    add_column :device_reports, :users, :integer
    add_column :device_reports, :load1, :float
    add_column :device_reports, :load5, :float
    add_column :device_reports, :load15, :float
    add_column :device_reports, :temperature, :float
    add_column :device_reports, :memory_free, :integer
    add_column :device_reports, :memory_total, :integer
    add_column :device_reports, :memory_used, :integer
    add_column :device_reports, :heartbeat_response_time, :float
    add_column :device_reports, :disk_available, :integer
    add_column :device_reports, :disk_total, :integer
    add_column :device_reports, :disk_used, :integer
    add_column :device_reports, :bandwidth, :float
    add_column :device_reports, :current_recording_size, :integer
    add_column :device_reports, :number_of_audio_devices, :integer
    add_column :device_reports, :number_of_usb_devices, :integer
  end
end
