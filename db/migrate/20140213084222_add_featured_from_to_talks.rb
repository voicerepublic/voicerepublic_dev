class AddFeaturedFromToTalks < ActiveRecord::Migration[6.0]
  def change
    add_column :talks, :featured_from, :datetime
  end
end
