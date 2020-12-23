class AddUserOverrideUuidToTalk < ActiveRecord::Migration[6.0]
  def change
    add_column :talks, :user_override_uuid, :string
  end
end
