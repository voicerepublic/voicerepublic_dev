class AddTitleToEvents < ActiveRecord::Migration[6.0]
  def change
    add_column :events, :title, :string
  end
end
