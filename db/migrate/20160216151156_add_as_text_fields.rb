class AddAsTextFields < ActiveRecord::Migration
  def change

    add_column :talks, :description_as_text, :text, default: ''
    add_column :series, :description_as_text, :text, default: ''
    add_column :users, :about_as_text, :text, default: ''

  end
end
