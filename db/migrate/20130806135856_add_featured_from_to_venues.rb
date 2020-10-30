class AddFeaturedFromToVenues < ActiveRecord::Migration[6.0]
  def change
    add_column :venues, :featured_from, :datetime
  end
end
