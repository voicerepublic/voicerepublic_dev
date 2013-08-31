class AddSummaryToVenues < ActiveRecord::Migration
  def change
    add_column :venues, :summary, :text
  end
end
