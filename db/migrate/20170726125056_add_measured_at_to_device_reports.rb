class AddMeasuredAtToDeviceReports < ActiveRecord::Migration
  def change
    add_column :device_reports, :measured_at, :datetime
  end
end
