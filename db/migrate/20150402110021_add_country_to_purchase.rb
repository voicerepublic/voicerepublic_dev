class AddCountryToPurchase < ActiveRecord::Migration
  def change
    add_column :purchases, :country, :string
  end
end
