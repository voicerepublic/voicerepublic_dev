class AddUriToTalksAndVenues < ActiveRecord::Migration[6.0]
  def change
    add_column :talks, :uri, :string
    add_index  :talks, :uri
    add_column :venues, :uri, :string
    add_index  :venues, :uri
  end
end
