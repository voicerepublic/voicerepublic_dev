class AddPeaksToTalks < ActiveRecord::Migration[6.0]
  def change
    add_column :talks, :peaks, :text
  end
end
