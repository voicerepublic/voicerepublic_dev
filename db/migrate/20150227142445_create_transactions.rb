class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.string :type
      t.string :state
      t.text :details
      t.references :source, polymorphic: true, index: true

      t.datetime :failed_at
      t.datetime :processed_at
      t.timestamps
    end
  end
end
