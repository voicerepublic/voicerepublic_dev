class AddFeaturedFromToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :featured_from, :datetime
  end
end
