class AddCountryToPurchase < ActiveRecord::Migration[6.0]
  def change
    add_column :purchases, :country, :string
  end
end
