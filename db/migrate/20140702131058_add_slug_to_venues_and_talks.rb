class AddSlugToVenuesAndTalks < ActiveRecord::Migration
  def change
    add_column :venues, :slug, :string
    add_index  :venues, :slug, unique: true
    add_column :talks, :slug, :string
    add_index  :talks, :slug, unique: true
  end
end
