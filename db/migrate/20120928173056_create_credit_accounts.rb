class CreateCreditAccounts < ActiveRecord::Migration
  def change
    create_table :credit_accounts do |t|
      t.integer :user_id
      t.integer :prepaid_amount
      t.integer :revenue_amount
      t.string :currency

      t.timestamps
    end
  end
end
