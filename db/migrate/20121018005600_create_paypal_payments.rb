class CreatePaypalPayments < ActiveRecord::Migration[6.0]
  def change
    create_table :paypal_payments do |t|
      t.text :params
      t.integer :check_in_order_id
      t.string :status
      t.integer :amount_cents
      t.string :tact_id
      t.string :currency

      t.timestamps
    end
  end
end
