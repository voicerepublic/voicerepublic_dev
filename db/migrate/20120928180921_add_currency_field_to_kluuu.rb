class AddCurrencyFieldToKluuu < ActiveRecord::Migration[6.0]
  def change
    add_column :klus, :currency, :string
  end
end
