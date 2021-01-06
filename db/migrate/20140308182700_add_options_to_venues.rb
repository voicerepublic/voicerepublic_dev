class AddOptionsToVenues < ActiveRecord::Migration[6.0]
  def change
    add_column :venues, :options, :text, default: {}.to_yaml
  end
end
