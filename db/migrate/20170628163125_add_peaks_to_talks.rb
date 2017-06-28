class AddPeaksToTalks < ActiveRecord::Migration
  def change
    add_column :talks, :peaks, :text
  end
end
