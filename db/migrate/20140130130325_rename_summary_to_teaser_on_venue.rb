class RenameSummaryToTeaserOnVenue < ActiveRecord::Migration[6.0]
  def change
    rename_column :venues, :summary, :teaser
  end
end
