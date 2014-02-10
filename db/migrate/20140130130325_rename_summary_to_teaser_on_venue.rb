class RenameSummaryToTeaserOnVenue < ActiveRecord::Migration
  def change
    rename_column :venues, :summary, :teaser
  end
end
