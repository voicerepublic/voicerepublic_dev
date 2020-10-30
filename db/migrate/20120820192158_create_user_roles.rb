class CreateUserRoles < ActiveRecord::Migration[6.0]
  def up
    create_table :roles do |t|
      t.string :name
    end
    #Role.reset_column_information
    
    create_table :user_roles do |t|
      t.integer :user_id
      t.integer :role_id
    end
    
  end

  def down
    drop_table :roles
    drop_table :user_roles
  end
end
