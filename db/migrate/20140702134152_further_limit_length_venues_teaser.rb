class FurtherLimitLengthVenuesTeaser < ActiveRecord::Migration[6.0]
  def change
    execute "UPDATE venues SET teaser = SUBSTRING(teaser from 1 for 140)"
  end
end
