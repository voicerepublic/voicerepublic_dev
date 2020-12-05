class ChangeVenuesTeaserToString < ActiveRecord::Migration[6.0]
  def change
    # truncate teasers to 255 characters
    execute 'UPDATE venues SET teaser = SUBSTRING(teaser from 1 for 255)'

    change_column :venues, :teaser, :string
  end
end
