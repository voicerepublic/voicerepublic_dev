class AddFacebookLiveUrlToVenues < ActiveRecord::Migration[6.0]
  def change
    add_column :venues, :facebook_live_url, :string
  end
end
