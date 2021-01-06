class AddDefaultsToTalks < ActiveRecord::Migration[6.0]
  def change
    change_column :talks, :duration, :integer, default: 30
    change_column :talks, :record, :boolean, default: true
  end
end
