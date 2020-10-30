class Cleanup < ActiveRecord::Migration[6.0]
  def change
    remove_column :users, :conference
    remove_column :users, :publisher_type

    remove_column :talks, :collect
    remove_column :talks, :grade

    add_column :users, :featured_until, :datetime

    add_column :users, :image_alt, :string, default: ''
    add_column :series, :image_alt, :string, default: ''
  end
end
