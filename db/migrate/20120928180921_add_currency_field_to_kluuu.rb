class AddCurrencyFieldToKluuu < ActiveRecord::Migration
  def change
    add_column :klus, :currency, :string
  end
end
