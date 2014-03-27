class AddDefaultsToTalks < ActiveRecord::Migration
  def change
    change_column :talks, :duration, :integer, default: 30
    change_column :talks, :record, :boolean, default: true
  end
end
