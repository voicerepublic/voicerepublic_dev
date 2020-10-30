class AddPreferencesFieldToAccount < ActiveRecord::Migration[6.0]
  def change
    add_column :accounts, :prefs, :text
  end
end
