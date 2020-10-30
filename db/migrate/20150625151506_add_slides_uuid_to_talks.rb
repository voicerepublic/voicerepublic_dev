class AddSlidesUuidToTalks < ActiveRecord::Migration[6.0]
  def change
    add_column :talks, :slides_uuid, :string
  end
end
