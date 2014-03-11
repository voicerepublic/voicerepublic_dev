class AddOptionsToVenues < ActiveRecord::Migration
  def change
    add_column :venues, :options, :text, default: {}.to_yaml
  end
end
