class CreateTransfers < ActiveRecord::Migration[6.0]
  def change
    create_table :transfers do |t|
      t.integer :account_id
      t.integer :video_session_id
      t.integer :duration
      t.integer :transfer_charge_cents
      t.string :transfer_charge_currency
      t.integer :transfer_gross_cents
      t.string :transfer_gross_currency
      t.integer :video_session_charge_cents
      t.string :video_session_charge_currency
      t.decimal :exchange_rate, :precision => 10, :scale => 5
      t.string :video_session_klu_name
      t.timestamps
    end
  end
end
