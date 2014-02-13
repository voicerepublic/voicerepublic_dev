class AddFeaturedFromToTalks < ActiveRecord::Migration
  def change
    add_column :talks, :featured_from, :datetime
  end
end
