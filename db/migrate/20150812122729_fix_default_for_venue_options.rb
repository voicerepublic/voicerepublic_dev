class FixDefaultForVenueOptions < ActiveRecord::Migration[6.0]
  def change

    change_column :venues, :options, :text, default: "--- {}\n"

  end
end
