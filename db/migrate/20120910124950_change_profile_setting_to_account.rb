class ChangeProfileSettingToAccount < ActiveRecord::Migration[6.0]
  def change
    rename_table :profile_settings, :accounts
  end
end
