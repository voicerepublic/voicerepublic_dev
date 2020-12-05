class AddGradeToTalks < ActiveRecord::Migration[6.0]
  def change
    add_column :talks, :grade, :string
    add_index :talks, :grade
  end
end
