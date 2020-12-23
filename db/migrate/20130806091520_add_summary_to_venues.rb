class AddSummaryToVenues < ActiveRecord::Migration[6.0]
  def change
    add_column :venues, :summary, :text
  end
end
