class CreateCategories < ActiveRecord::Migration[6.0]
  def up
    create_table :categories do |t|
      t.string :name
      t.integer :parent_id
      t.integer :lft
      t.integer :rgt

      t.timestamps
    end
    #Category.reset_column_information
    #Category.create_translation_table! :name => :string
  end
  
  def down
    drop_table :categories
    #Category.drop_translation_table!
  end
end
