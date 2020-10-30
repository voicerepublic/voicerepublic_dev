class CreateReminders < ActiveRecord::Migration[6.0]
  def change
    create_table :reminders do |t|
      t.references :user, index: true
      t.references :rememberable, polymorphic: true, index: true

      t.timestamps
    end
  end
end
