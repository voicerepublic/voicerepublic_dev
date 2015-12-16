class AddFeaturedFromToUsers < ActiveRecord::Migration
  def change
    add_column :users, :featured_from, :datetime
  end
end
