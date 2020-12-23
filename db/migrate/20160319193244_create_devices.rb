class CreateDevices < ActiveRecord::Migration[6.0]
  def change
    create_table :devices do |t|
      t.string :identifier
      t.string :type
      t.string :subtype
      t.string :name
      t.string :state
      t.datetime :last_heartbeat_at
      t.references :organization, index: true
      t.datetime :paired_at

      t.timestamps null: false
    end
    add_foreign_key :devices, :organizations
  end
end
