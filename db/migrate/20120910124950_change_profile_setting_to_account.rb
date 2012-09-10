class ChangeProfileSettingToAccount < ActiveRecord::Migration
  def change
    rename_table :profile_settings, :accounts
  end
end
