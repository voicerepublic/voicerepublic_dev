class AddConferenceToUsers < ActiveRecord::Migration
  def change
    add_column :users, :conference, :boolean
  end
end
