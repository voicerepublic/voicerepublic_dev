class FurtherLimitLengthTalksTitleAndTeaser < ActiveRecord::Migration[6.0]
  def change
    execute "UPDATE talks SET title = SUBSTRING(title from 1 for 140)"
    execute "UPDATE talks SET teaser = SUBSTRING(teaser from 1 for 140)"
  end
end
