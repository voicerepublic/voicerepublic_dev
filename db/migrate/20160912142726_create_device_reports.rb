class CreateDeviceReports < ActiveRecord::Migration
  def change
    create_table :device_reports do |t|
      t.references :device, index: true
      t.text :data

      t.timestamps null: false
    end
    add_foreign_key :device_reports, :devices
  end
end
