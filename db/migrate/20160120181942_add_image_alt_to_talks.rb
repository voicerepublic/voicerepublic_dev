class AddImageAltToTalks < ActiveRecord::Migration[6.0]
  def change
    add_column :talks, :image_alt, :string
  end
end
