class AddContactEmailToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :contact_email, :string
  end
end
