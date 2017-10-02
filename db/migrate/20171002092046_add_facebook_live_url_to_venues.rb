class AddFacebookLiveUrlToVenues < ActiveRecord::Migration
  def change
    add_column :venues, :facebook_live_url, :string
  end
end
