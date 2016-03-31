class AddContactEmailToUsers < ActiveRecord::Migration
  def change
    add_column :users, :contact_email, :string
  end
end
