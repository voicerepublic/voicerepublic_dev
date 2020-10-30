class CreatePurchases < ActiveRecord::Migration[6.0]
  def change
    create_table :purchases do |t|
      t.integer :quantity, default: 1
      t.integer :amount
      t.datetime :purchased_at
      t.string :ip
      t.string :express_token
      t.string :express_payer_id

      t.timestamps
    end
  end
end
