class AddPreferencesFieldToAccount < ActiveRecord::Migration
  def change
    add_column :accounts, :prefs, :text
  end
end
