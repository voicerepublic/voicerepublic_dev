class FurtherLimitLengthVenuesTeaser < ActiveRecord::Migration
  def change
    execute "UPDATE venues SET teaser = SUBSTRING(teaser from 1 for 140)"
  end
end
