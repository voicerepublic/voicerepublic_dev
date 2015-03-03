class CreateMetrics < ActiveRecord::Migration
  def change
    create_table :metrics do |t|
      t.string :key, index: true
      t.float :value

      t.datetime :created_at, index: true
    end
  end
end
