class FixDefaultForVenueOptions < ActiveRecord::Migration
  def change

    change_column :venues, :options, :text, default: "--- {}\n"

  end
end
