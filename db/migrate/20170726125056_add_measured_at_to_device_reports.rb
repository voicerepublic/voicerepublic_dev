class AddMeasuredAtToDeviceReports < ActiveRecord::Migration[6.0]
  def change
    add_column :device_reports, :measured_at, :datetime
  end
end
