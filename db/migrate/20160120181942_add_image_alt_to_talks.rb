class AddImageAltToTalks < ActiveRecord::Migration
  def change
    add_column :talks, :image_alt, :string
  end
end
