class AddGradeToTalks < ActiveRecord::Migration
  def change
    add_column :talks, :grade, :string
    add_index :talks, :grade
  end
end
