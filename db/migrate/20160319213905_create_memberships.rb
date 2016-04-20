class CreateMemberships < ActiveRecord::Migration
  def change
    create_table :memberships do |t|
      t.references :user, index: true
      t.references :organization, index: true

      t.timestamps null: false
    end
    add_foreign_key :memberships, :users
    add_foreign_key :memberships, :organizations
  end
end
