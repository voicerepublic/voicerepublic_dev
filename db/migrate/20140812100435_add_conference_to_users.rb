class AddConferenceToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :conference, :boolean
  end
end
