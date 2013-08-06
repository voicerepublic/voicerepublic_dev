class AddFeaturedFromToVenues < ActiveRecord::Migration
  def change
    add_column :venues, :featured_from, :datetime
  end
end
