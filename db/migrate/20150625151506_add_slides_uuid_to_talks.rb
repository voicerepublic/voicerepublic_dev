class AddSlidesUuidToTalks < ActiveRecord::Migration
  def change
    add_column :talks, :slides_uuid, :string
  end
end
