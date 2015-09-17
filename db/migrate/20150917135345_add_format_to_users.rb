class AddFormatToUsers < ActiveRecord::Migration
  def change
    add_column :users, :format, :string

    # prepopulate with existing data
    execute "UPDATE users SET format='conference' WHERE conference IS TRUE;"
  end
end
