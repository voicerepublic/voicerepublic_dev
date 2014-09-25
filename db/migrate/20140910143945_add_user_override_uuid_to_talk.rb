class AddUserOverrideUuidToTalk < ActiveRecord::Migration
  def change
    add_column :talks, :user_override_uuid, :string
  end
end
